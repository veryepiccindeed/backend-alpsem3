import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk jadwal keberangkatan
    final List<Map<String, dynamic>> scheduleList = List.generate(5, (index) {
      return {
        'time': '07.30',
        'route': 'Trayek A',
        'distance': '15 km halte terdekat dari lokasimu',
        'details': 'MP - Jalan Boulevard Panakkukang - Jalan AP Pettarani - Jalan Dr. Ratulangi'
      };
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text(
          'Jadwal dan Trayek',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Column(
        children: [
          // Bagian Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const Text(
              'Jadwal dan Trayek',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ListView untuk menampilkan jadwal
          Expanded(
            child: ListView.builder(
              itemCount: scheduleList.length,
              itemBuilder: (context, index) {
                final schedule = scheduleList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Waktu dan Trayek
                          Row(
                            children: [
                              const Icon(Icons.camera_alt, color: Colors.cyan),
                              const SizedBox(width: 10),
                              Text(
                                schedule['time'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                schedule['route'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Jarak halte terdekat
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.cyan, size: 16),
                              const SizedBox(width: 5),
                              Text(
                                schedule['distance'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Detail trayek
                          Text(
                            schedule['details'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
