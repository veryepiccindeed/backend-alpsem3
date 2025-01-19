import 'package:flutter/material.dart';
import 'package:flutter_pete/screens/History.dart';
import 'package:flutter_pete/screens/home_screen.dart';
import 'package:flutter_pete/screens/profile_screen.dart';

class FAQScreen extends StatelessWidget {
  final String username;
  final String userToken;

  const FAQScreen({Key? key, required this.username, required this.userToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqList = [
      {
        'question':
            'Bagaimana cara melakukan pembayaran setelah memesan kursi?',
        'answer':
            'Setelah memilih kursi, Anda dapat melakukan pembayaran melalui metode yang tersedia di aplikasi, seperti e-wallet, transfer bank, atau pembayaran tunai.',
      },
      {
        'question':
            'Apa yang harus saya lakukan jika aplikasi mengalami error?',
        'answer':
            'Coba tutup dan buka kembali aplikasi. Jika masalah berlanjut, hubungi tim dukungan kami melalui menu bantuan.',
      },
      {
        'question': 'Apakah saya dapat memesan kursi untuk hari berikutnya?',
        'answer': 'Ya, Anda dapat memesan kursi hingga 7 hari sebelumnya.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FAQ',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Kembali ke HomeScreen, bukan halaman sebelumnya
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(username: username, userToken: userToken),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cara Membayar?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: faqList.length,
                itemBuilder: (context, index) {
                  final faq = faqList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            faq['question']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            faq['answer']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(username: username, userToken: userToken),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HistoryScreen(username: username, userToken: userToken),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FAQScreen(username: username, userToken: userToken),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(username: username, userToken: userToken),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: 'FAQ'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
