import 'package:flutter/material.dart';
import 'package:flutter_pete/screens/schedulemaps_screen.dart';
import 'package:latlong2/latlong.dart';

class TrayekListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> trayekList = [
    {
      'name': 'Trayek A',
      'Go': 'BTN Minasa Upa – Syech Yusuf – Sultan Alauddin – Andi Tonro – Kumala – Ratulangi – Jendral Sudirman (Karebosi Timur) – HOS Cokroaminoto (Sentral) – KH. Wahid Hasyim – Wahidin Sudirohusodo – Pasar Butung',
      'Back': 'Pasar Butung – Sulawesi – Riburane Achmad Yani (Balaikota) – Jendral Sudirman – Ratulangi (MaRI) – Landak – Veteran – Sultan Alauddin – Syech Yusuf – BTN Minasa Upa',
      'locations': [
        LatLng(-5.1862518741076, 119.4549252153959), // Lokasi A
        LatLng(-5.189225844106793, 119.44795864917056), // Lokasi B
        LatLng(-5.1746123048921335, 119.43298482917724), // Lokasi C
        LatLng(-5.172427182002852, 119.42201452341928), // Lokasi D
        LatLng(-5.178739738645198, 119.41969856998148), // Lokasi E
        LatLng(-5.164657795101395, 119.4172607242575), // Lokasi F
        LatLng(-5.133093353032515, 119.41216306861821), // Lokasi G
        LatLng(-5.1309012556305555, 119.41381375888604), // Lokasi H
        LatLng(-5.1281611232884945, 119.41359366685033), // Lokasi I
        LatLng(-5.134568360110945, 119.4956636125877), // Lokasi J
        LatLng(-5.123353640137265, 119.41222685030239), // Lokasi K
      ],
    },
    {
      'time': '08.30',
      'name': 'Trayek B',
      'Go': 'Terminal Tamalate – Malengkeri – Daeng Tata – Abdul Kadir – Dangko – Cendrawasih – Arief Rate – Sultan Hasanuddin – Patimura – Ujungpandang – Riburane – Jendral Achmad Yani (Balaikota) – Pasar Butung',
      'Back': 'Pasar Butung – Sulawesi – Achmad Yani – Kajaolalido (Karebosi Timur) – Botolempangan – Arief Rate – Cendrawasih – Dangko – Abdul Kadir – Daeng Tata – Malengkeri – Terminal Tamalate',
      'location': LatLng(-5.144500, 119.436000),
    },
    {
      'time': '09.30',
      'name': 'Trayek C',
      'Go': 'KH.Wahid.Hasyim – DR Wahidin Sudirohusodo- Buru – Bandang – Masjid Raya – Cumi-cumi – Pongtiku – Ujungpandang Baru – Gatot Subroto – Juanda – Regge – Rappokalling',
      'Back': 'Rappokalling – Korban 40 ribu – Juanda – Gatot Subroto – UjungpandangBaru – Pongtiku – Datok Ditiro – Sunu – Masjid Raya – Bawakaraeng – Jenderal Sudirman – HOS Cokroaminoto – KH.Wahid Hasyim – Makassar Mall',
      'location': LatLng(-5.139072, 119.417488),
    },
    {
      'time': '10.30',
      'name': 'Trayek D',
      'Go': 'Terminal Daya – Perintis Kemerdekaan – Urip Sumoharjo – AP. Pettarani – Bawakaraeng – Latimojong – Andalas – Laiya – Selatan Makassar Mall',
      'Back': 'Selatan Makassar Mall – HOS Cokroaminoto – Bulusaraung – Masjid Raya – Urip Sumoharjo – Perintis Kemerdekaan – Terminal Daya',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '11.30',
      'name': 'Trayek E',
      'Go': 'Terminal Panakkukang – Toddoppuli – Tamalate – Emmy Saelan – Mapala – AP. Pettarani – Maccini Raya – Urip Sumoharjo – Bawakaraeng – Latimojong – Andalas – Laiya – KH.Agus Salim – Timur Makassar Mall',
      'Back': 'KH. Agus Salim – Pangeran Diponegoro – Bandang – Masjid Raya – UripSumoharjo -AP. Pettarani – Mapala – Emmy Saelan – Tamalate – Todoppuli – TerminalPanakkukang',
      'location': LatLng(-5.131532, 119.438939),
    },
    {
      'time': '12.30',
      'name': 'Trayek F',
      'Go': 'Terminal Tamalate – Mallengkeri – Daeng Tata – Daeng Ngeppe – Kumala – Veteran – Bandang – Buru – Andalas – Satangnga – KH. Agus Salim – Timur Makassar Mall',
      'Back': 'KH Agus Salim – Pangeran Diponegoro – Andalas – Buru – Bandung – Veteran – Sultan Alauddin – Andi Tonro – Kumala – Daeng Ngeppe – Daeng Tata-Mallengkeri – Terminal Tamalate',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '13.30',
      'name': 'Trayek G',
      'Go': 'Terminal Daya – Kima – TOL (Ir. Sutami) – Tinumbu – Cakalang – YosSudarso – Tentara Pelajar – Kalimantan – Pasar Butung',
      'Back': 'Pasar Butung – Kalimantan – Cakalang – Tinumbu – TOL (Ir. Sutami) – Kima – Terminal Daya',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '14.30',
      'name': 'Trayek H',
      'Go': 'Perumnas Antang – Antang Raya – Urip Sumiharjo – Bawakaraeng – Jenderal Sudirman – DR. Wahidin Sudirohusodo – Satando – Kalimantan – Pasar Butung',
      'Back': 'Pasar Butung – Kalimantan – Satando – DR. Wahidin Sudirohusodo – Tentara Pelajar – Ujung – Bandang – Masjid Raya – Perumnas Antang',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '15.30',
      'name': 'Trayek I',
      'Go': 'Terminal Daya – Kima – TOL (Ir. Sutami) – Tinumbu – Cakalang – YosSudarso – Tentara Pelajar – Kalimantan – Pasar Butung',
      'Back': 'Pasar Baru – Pattimura – Ujungpandang – Riburane – Ahmad Yani(Balaikota) – Kajaolalido – Botolempangan – Karungrung – Sungai Saddang – Sungai Saddang Baru – Pelita Raya – AP. Pettarani – Abdullah Daeng Sirua – Batua Raya – Borong – Toddopuli Raya -Terminal Panakkukang',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '16.30',
      'name': 'Trayek J',
      'Go': 'Terminal Panakkukang – Toddopuli Raya – Tamalate – Emmy Saelan – Sultan Alauddin – Andi Tonro – Kumala – Ratulangi – Jenderal Sudirman – HOSCokroaminoto – Nusakambangan',
      'Back': 'Nusakambangan – Ahmad Yani – Jenderal Sudirman – DR. Sam Ratulangi – Landak – Veteran – Sultan Alaudin – Emmy Saelan – Tamalate – Toddopuli Raya – Terminal Panakkukang',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '17.30',
      'name': 'Trayek K',
      'Go': 'Terminal Panaikang – Urip Sumoharjo – Taman Makam Pahlawan – Abdullah Daeng Sirua – Adiyaksa – Terminal Panakkukang – Toddopuli Raya – Tamalate – Emmy Saelan – Sultan Alauddin – Terminal Tamalate',
      'Back': 'Terminal Tamalate – Sultan Alauddin – Emmy Saelan – Toddopuli Raya – Terminal Panakkukang – Adiyaksa – Abdullah Daeng Sirua – Taman Makam Pahlawan – Urip Sumoharjo – Terminal Panaikang',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '18.30',
      'name': 'Trayek L',
      'Go': 'Terminal Tamalate – Mallengkeri – Daeng Tata – Daeng Ngeppe – Kumala – Mallong Bassang – Mappaoddang – Mangerangi – Baji Ateka – Baji Minasa –  Nuri – Rajawali – Penghibur – Pasar Ikan – Ujungpandang – Nusantara – Butung – Pasar Butung',
      'Back': 'Pasar Butung – Butung – Sulawesi – Riburane – Ujungpandang – Pattimura – Somba Opu – Rajawali – Gagak – Nuri – Baji Minasa – Cendrawasih – Dangko – Abd.Kadir – Daeng Tata – Mallengkeri – Terminal Tamalate',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '19.30',
      'name': 'Trayek M',
      'Go': 'Terminal Panaikang – Urip Sumoharjo – AP.Pettarani – Rappocini Raya – Veteran – Ratulangi – Kakatua – Cendrawasih – Tanjung Alang',
      'Back': 'Tanjung Alang -Tanjung Rangas – Cendrawasih – Kakatua – Landak – Veteran – Sultan Alauddin – AP. Pettarani – Urip Sumoharjo – Terminal Panaikang',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '20.30',
      'name': 'Trayek N',
      'Go': 'Terminal Tamalate – Sultan Alauddin – Syeh Yusuf – Jipang Raya – SMA9 – Tidung Raya – Tamalate – Toddopuli Raya – Terminal Pakkukang',
      'Back': 'Terminal Panakkukang – Toddopuli Raya -Tamalate – Tidung Raya – SMA9 – Jipang Raya – Tala Salapang – Sultan Alauddin – Terminal Tamalate',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '21.30',
      'name': 'Trayek O',
      'Go': 'Terminal Panaikang – Urip Sumoharjo – Taman Makam Pahlawan – Batua Raya – Toddopuli Raya -Pengayoman – AP. Pettarani – Urip Sumoharjo – Bawakaraeng – Veteran Utara – Bandang – Ujung – Yos. Sudarso – Tarakan – Kalimantan – Pasar Butung',
      'Back': 'Pasar Butung – Kalimantan – Satando – Yos. Sudarso – Ujung – Bandang – Masjid Raya – Urip Sumoharjo – AP. Pettarani – Panakkukang – Adiyaksa – Urip Sumoharjo – Terminal Panaikang',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '22.30',
      'name': 'Trayek P',
      'Go': 'Terminal Panaikang – Urip Sumoharjo – AP. Pettarani – Landak Baru – Veteran – DR. Sam Ratulangi – Mappaoddang – Daeng Ngeppe – Daeng Tata – Mallengkeri – Terminal Tamalate',
      'Back': 'Terminal Tamalate – Mallengkeri – Daeng Tata – Daeng Ngeppe – Kumala – DR. Sam Ratulangi – Landak – Landak Baru – AP. Pettarani – Urip Sumoharjo – TerminalPanaikang',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '23.30',
      'name': 'Trayek U',
      'Go': 'Pasar Pannampu – Tinumbu – Cakalang – Yos. Sudarso – Andalas – Latimojong – Bulukunyi – Rusa – Lanto Dg. Pasewang – DR. Sam. Ratulangi – Landak – Veteran – Sultan Alauddin – Terminal Tamalate',
      'Back': 'Terminal Tamalate – Sultan Alauddin – Andi Tonro – Kumala – DR. SamRatulangi – Lanto Dg. Pasewang – Rusa – Bulukunyi – Latimojong – Andalas – Yos.Sudarso – Cakalang – Tinumbu – Pasar Pannampu',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '00.30',
      'name': 'Trayek R',
      'Go': 'Pasar Baru – Ujungpandang – Nusantara – Pasar Butung – Tentara Pelajar  – Kalimantan – Satando -Yos. Sudarso – Ujung – Bandang – Masjid Raya – Urip Sumoharjo – Perintis Kemerdekaan – Kampus Unhas',
      'Back': 'Kampus Unhas – Perintis Kemerdekaan – Urip SUmoharjo – Bawakaraeng – Kartini – Botolempangang – Usman Jafar – Sultan Hasanuddin – Pattimura – Pasar Baru',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '01.30',
      'name': 'Trayek V1',
      'Go': 'Terminal Daya – Paccerakkang – Mangga Tiga',
      'Back': 'Mangga Tiga – Paccerakkang – Terminal Day',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '02.30',
      'name': 'Trayek V2',
      'Go': 'Sudiang – KNPI – Terminal Daya',
      'Back': 'Terminal Daya – KNPI – Sudiang',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '03.30',
      'name': 'Trayek V3',
      'Go': 'Pasar Daya – Paccerakang – Mongcongloe – Pangnyangkallang',
      'Back': 'Pangnyangkallang – Mongcongloe – Paccerakang – Daya',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '04.30',
      'name': 'Trayek W',
      'Go': ' Terminal Daya – KIMA – Kapasa – SMA 6 – Ir. Sutami – Salodong – Desa Nelayan',
      'Back': 'Desa Nelayan – Salodong – Ir. Sutami – SMA 6 – Kapasa – KIMA – Terminal Daya',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '05.30',
      'name': 'Trayek B1',
      'Go': 'Teminal Tamalate – Mallengkeri – Daeng Tata – Abd. Kadir – Dangko – Cendrawasih – Arif Rate – Sultan Hasanudin – Sawerigading – Botolempangan – Karunrung – Sungai Saddang – Latimojong – Masjid Raya – Urip Sumoharjo – Perintis Kemerdekaan – Kampus Unhas',
      'Back': 'Kampus Unhas – Perintis Kemerdekaan – Urip SUmoharjo – Bawakaraeng – Kartini – Botolempangan – Arif Rate – Cendrawasih – Dangko – Abd. Kadir – Daeng Tata – Mallengkeri – Tamalate',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '06.30',
      'name': 'Trayek C1',
      'Go': ' : Korban 40 ribu – Ujungpandang Baru – Pongtiku – Cumi-cumi – Laccukang – Sunu – Masjid Raya – Urip Sumoharjo – Perintis Kemerdekaan – Kampus Unhas',
      'Back': 'Kampus Unhas – Perintis Kemerdekaan – Urip Sumoharjo – Bawakaraeng – Jenderal Sudirman – HOS Cokroaminoto – DR. Wahidin Sudirohusodo – Tentara Pelajar – Ujung – Bandang – Masjid Raya – Sunu – Teuku Umar – Gatot Subroto – Korban 40 ribu',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '07.30',
      'name': 'Trayek E1',
      'Go': 'Terminal Panakkukang – Toddopuli Raya – Perumnas – Hertasning – AP.Pettarani – Kampus IKIP – Gunung Sari – AP. Pettarani – Pelita Raya – AP. Pettarani – Abdullah Daeng Sirua – PLTU – Urip Sumoharjo – Perintis Kemerdekaan – Kampus Unhas',
      'Back': 'Kampus Unhas – Perintis Kemerdekaan – Urip SUmoharjo – PLTU – Abdullah Daeng Sirua – AP. Pettarani – Kampus IKIP – Gunung Sari – AP. Pettarani – Hertasning – Perumnas – Toddopuli Raya – Panakkukang',
      'location': LatLng(-5.135825, 119.429993),
    },
    {
      'time': '08.30',
      'name': 'Trayek F1',
      'Go': 'Terminal Tamalate – Mallengkeri – Daeng Tata – M. Tahir – Kumala – Veteran – Masjid Raya – Urip Sumoharjo – Perintis Kemerdekaan – Kampus Unhas',
      'Back': 'Kampus Unhas – Perintis Kemerdekaan – Urip Sumoharjo – AP. Pettarani – Abubakar Lambogo – Veteran – Sultan Alauddin – Andi Tonro – Kumala – M.Tahir – DaengTata – Mallengkeri – Terminal Tamalate',
      'location': LatLng(-5.135825, 119.429993),
    }
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jadwal dan Trayek',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: trayekList.length,
        itemBuilder: (context, index) {
          final trayek = trayekList[index];
          return GestureDetector(
            onTap: () {
              // Navigasi ke MapScreen dengan mengirim data trayek
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(
                    trayekName: trayek['name'],
                    goRoute: trayek['Go'],
                    backRoute: trayek['Back'],
                    locations: trayek['locations'],
                  ),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
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
                            trayek['name'],
                            style: TextStyle(fontSize: size.width * 0.04),
                          ),
                          SizedBox(height: size.height * 0.005),
                          Text(
                            'Rute berangkat:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: size.height * 0.005),
                          Text(
                            trayek['Go'],
                            style: TextStyle(fontSize: size.width * 0.020),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: size.height * 0.005),
                          Text(
                            'Rute balik:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: size.height * 0.005),
                          Text(
                            trayek['Back'],
                            style: TextStyle(fontSize: size.width * 0.020),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
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