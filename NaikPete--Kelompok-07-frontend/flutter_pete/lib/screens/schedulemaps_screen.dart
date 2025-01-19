import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_pete/screens/Drivescreen.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:polyline_codec/polyline_codec.dart'; // Untuk decode polyline
import 'package:geolocator/geolocator.dart'; // Untuk mendapatkan lokasi pengguna

class MapScreen extends StatefulWidget {
  final String trayekName;
  final String goRoute;
  final String backRoute;
  final List<LatLng> locations;

  const MapScreen({
    required this.trayekName,
    required this.goRoute,
    required this.backRoute,
    required this.locations,
    Key? key,
  }) : super(key: key);

  @override
  _RouteMapPageState createState() => _RouteMapPageState();
}

class _RouteMapPageState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<LatLng> routePoints = [];
  int passengerCount = 0; // Jumlah penumpang
  bool isJourneyStarted = false; // Status perjalanan
  LatLng? userLocation; // Lokasi pengguna
  bool isLoading = true; // Status loading lokasi

  @override
  void initState() {
    super.initState();
    _fetchRoute();
    _getUserLocation();
  }

  Future<void> _fetchRoute() async {
    final apiKey = "4585cd0b-2f46-437c-9868-3645837b62e3"; // Ganti dengan API key Anda

    // Buat URL untuk rute antara semua lokasi
    final waypoints = widget.locations.map((loc) => "${loc.latitude},${loc.longitude}").join("&point=");
    final url =
        "https://graphhopper.com/api/1/route?point=$waypoints&vehicle=car&locale=id&instructions=false&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: ${response.body}'); // Debugging: Cetak respons API

        // Cek apakah respons mengandung encoded polyline
        if (data['paths'][0]['points'] is String) {
          // Jika points adalah encoded polyline
          final String encodedPolyline = data['paths'][0]['points'];
          final List<List<num>> decodedPoints = PolylineCodec.decode(
            encodedPolyline,
            precision: 5,
          );

          final List<LatLng> latLngPoints = decodedPoints
              .map((point) => LatLng(point[0].toDouble(), point[1].toDouble()))
              .toList();

          setState(() {
            routePoints = latLngPoints;
          });
        } else {
          print('Format points tidak dikenali');
        }
      } else {
        print('Gagal mengambil rute: ${response.statusCode}');
      }
    } catch (e) {
      print('Error mengambil rute: $e');
    }
  }

  // Fungsi untuk mendapatkan lokasi pengguna
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

      // Dapatkan lokasi pengguna
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mendapatkan lokasi: $e")),
      );
    }
  }

  void _showStartJourneyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Mulai Perjalanan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Anda akan memulai perjalanan untuk narik di sepanjang trayek berikut:",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                widget.trayekName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "Rute berangkat: ${widget.goRoute}",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 10),
              Text(
                "ANDA TIDAK DAPAT MENGUBAH STATUS SELAMA MEMBAWA PENUMPANG",
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                // Navigasi ke DriverScreen dengan membawa data trayek, rute, dan jumlah penumpang
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DriverScreen(
                      trayekName: widget.trayekName,
                      goRoute: widget.goRoute,
                      backRoute: widget.backRoute,
                      routePoints: routePoints, // Kirim rute points
                      passengerCount: 5, // Contoh: Jumlah penumpang awal (bisa disesuaikan)
                    ),
                  ),
                );
              },
              child: Text("OK"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog tanpa memulai perjalanan
              },
              child: Text("Batal"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPassengerOverlay() {
    Color overlayColor;

    if (passengerCount < 6) {
      overlayColor = Colors.green.withOpacity(0.7); // Hijau jika kurang dari 6 penumpang
    } else if (passengerCount >= 6 && passengerCount < 12) {
      overlayColor = Colors.yellow.withOpacity(0.7); // Kuning jika 6-11 penumpang
    } else {
      overlayColor = Colors.red.withOpacity(0.7); // Merah jika 12 penumpang
    }

    return Positioned.fill(
      child: Container(
        color: overlayColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Kapasitas Penumpang",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "$passengerCount/12",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trayekName),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: widget.locations.first, // Pusat peta di lokasi pertama
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
                    points: routePoints,
                    strokeWidth: 4.0,
                    color: Colors.blue,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  // Marker untuk setiap lokasi
                  ...widget.locations.map(
                    (location) => Marker(
                      width: 80.0,
                      height: 80.0,
                      point: location,
                      builder: (ctx) => const Icon(
                        Icons.location_on,
                        color: Colors.orange,
                        size: 30.0,
                      ),
                    ),
                  ),
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
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.trayekName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Rute berangkat: ${widget.goRoute}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Rute balik: ${widget.backRoute}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _showStartJourneyDialog(context); // Tampilkan dialog konfirmasi
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                    ),
                    child: const Text(
                      'Mulai perjalanan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Overlay penumpang (muncul hanya jika perjalanan dimulai)
          if (isJourneyStarted) _buildPassengerOverlay(),
        ],
      ),
    );
  }
}