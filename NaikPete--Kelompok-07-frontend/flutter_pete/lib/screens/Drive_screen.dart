import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart'; // Untuk mendapatkan lokasi real-time

class DriverScreen extends StatefulWidget {
  final String trayekName;
  final String goRoute;
  final String backRoute;
  final List<LatLng> routePoints;
  final int passengerCount;

  const DriverScreen({
    required this.trayekName,
    required this.goRoute,
    required this.backRoute,
    required this.routePoints,
    required this.passengerCount,
    Key? key,
  }) : super(key: key);

  @override
  _DriverScreenState createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final MapController _mapController = MapController();
  LatLng? userLocation; // Lokasi pengguna
  StreamSubscription<Position>? _positionStream; // Stream untuk pembaruan lokasi

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  void dispose() {
    _positionStream?.cancel(); // Hentikan stream saat halaman ditutup
    super.dispose();
  }

  // Fungsi untuk mendapatkan lokasi pengguna secara real-time
  Future<void> _getUserLocation() async {
    try {
      // Minta izin lokasi
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Jika layanan lokasi tidak aktif, minta pengguna mengaktifkannya
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Jika izin ditolak, tampilkan pesan
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Izin lokasi ditolak")),
          );
          return;
        }
      }

      // Dapatkan lokasi pengguna secara real-time
      _positionStream = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high, // Akurasi tinggi
          distanceFilter: 5, // Update setiap 10 meter
        ),
      ).listen((Position position) {
        setState(() {
          userLocation = LatLng(position.latitude, position.longitude);
        });

        // Geser peta ke lokasi pengguna yang baru
        _mapController.move(userLocation!, _mapController.zoom);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mendapatkan lokasi: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int maxSeats = 12;
    double percentage = widget.passengerCount / maxSeats;
    Color indicatorColor;
    String indicatorText;

    if (percentage == 1) {
      indicatorColor = Colors.red;
      indicatorText = "12/12, sudah penuh!";
    } else if (percentage >= 0.5) {
      indicatorColor = Colors.orange;
      indicatorText = "${widget.passengerCount}/12, kursi hampir penuh!";
    } else {
      indicatorColor = Colors.green;
      indicatorText = "${widget.passengerCount}/12, masih bisa narik!";
    }

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: widget.routePoints.isNotEmpty
                  ? widget.routePoints.first
                  : LatLng(-5.147665, 119.432731),
              zoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: widget.routePoints,
                    strokeWidth: 4.0,
                    color: Colors.blue,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  // Marker untuk lokasi pengguna
                  if (userLocation != null)
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: userLocation!,
                      builder: (ctx) => const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 40.0,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  indicatorText,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Trayek pete - pete anda",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.trayekName,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.directions_bus, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Rute berangkat: ${widget.goRoute}",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.directions_bus, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Rute balik: ${widget.backRoute}",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Simpan data trayek ke history
                      final tripHistory = TripHistory(
                        trayekName: widget.trayekName,
                        goRoute: widget.goRoute,
                        backRoute: widget.backRoute,
                        timestamp: DateTime.now(),
                      );
                      history.add(tripHistory);

                      // Kembali ke halaman home
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Center(
                      child: Text(
                        "Berhenti Narik",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TripHistory {
  final String trayekName;
  final String goRoute;
  final String backRoute;
  final DateTime timestamp;

  TripHistory({
    required this.trayekName,
    required this.goRoute,
    required this.backRoute,
    required this.timestamp,
  });
}

// List untuk menyimpan riwayat trayek
List<TripHistory> history = [];