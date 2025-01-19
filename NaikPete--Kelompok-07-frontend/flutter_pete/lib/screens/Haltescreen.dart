import 'package:flutter/material.dart';
import 'package:flutter_pete/screens/maphalte.dart';
import 'package:latlong2/latlong.dart';

class HalteListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> halteList = [
    {
      'name': 'Halte A',
      'jalan': 'BTN Minasa Upa',
      'location': LatLng(-5.1862518741076, 119.4549252153959),
    },
    {
      'name': 'Halte B',
      'jalan': 'Syech Yusuf',
      'location': LatLng(-5.189225844106793, 119.44795864917056),
    },
    {
      'name': 'Halte C',
      'jalan': 'Sultan Alauddin',
      'location': LatLng(-5.1746123048921335, 119.43298482917724),
    },
    {
      'name': 'Halte D',
      'jalan': 'Andi Tonro',
      'location': LatLng(-5.172427182002852, 119.42201452341928),
    },
    {
      'name': 'Halte E',
      'jalan': 'Kumala',
      'location': LatLng(-5.178739738645198, 119.41969856998148),
    },
    {
      'name': 'Halte F',
      'jalan': 'Ratulangi',
      'location': LatLng(-5.164657795101395, 119.4172607242575),
    },
    {
      'name': 'Halte G',
      'jalan': 'Jendral Sudirman (Karebosi Timur)',
      'location': LatLng(-5.133093353032515, 119.41216306861821),
    },
    {
      'name': 'Halte H',
      'jalan': 'HOS Cokroaminoto (Sentral)',
      'location': LatLng(-5.1309012556305555, 119.41381375888604),
    },
    {
      'name': 'Halte I',
      'jalan': 'KH. Wahid Hasyim',
      'location': LatLng(-5.1281611232884945, 119.41359366685033),
    },
    {
      'name': 'Halte J',
      'jalan': 'Wahidin Sudirohusodo',
      'location': LatLng(-5.134568360110945, 119.4956636125877),
    },
    {
      'name': 'Halte K',
      'jalan': 'Pasar Butung',
      'location': LatLng(-5.123353640137265, 119.41222685030239),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Halte',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: halteList.length,
        itemBuilder: (context, index) {
          final halte = halteList[index];
          return GestureDetector(
            onTap: () {
              // Navigasi ke MapScreen dengan lokasi halte yang dipilih
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapHalte(
                    halteName: halte['name'],
                    location: halte['location'],
                  ),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.directions_bus,
                      size: size.width * 0.1, // Ukuran icon responsif
                      color: Colors.blue,
                    ),
                    SizedBox(width: size.width * 0.04), // Padding horizontal
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            halte['name'],
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: size.height * 0.005),
                          Text(
                            halte['jalan'],
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}