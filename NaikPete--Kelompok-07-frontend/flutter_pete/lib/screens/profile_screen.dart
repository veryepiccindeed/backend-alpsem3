import 'dart:convert'; // Import package untuk base64Decode
import 'dart:typed_data'; // Import Uint8List
import 'package:flutter/material.dart';
import 'package:flutter_pete/network/api.dart'; // Sesuaikan dengan path yang benar
import 'package:flutter_pete/screens/History.dart';
import 'package:flutter_pete/screens/edit_profile.dart';
import 'package:flutter_pete/screens/faq_screen.dart';
import 'package:flutter_pete/screens/login_screen.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String userToken;

  const ProfileScreen({Key? key, required this.username, required this.userToken}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Network _network = Network();
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final response = await _network.getData('/profile'); // Endpoint profil
      print('Profile Response: ${response.body}'); // Log respons profil

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userProfile = data;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text('Error: $_errorMessage'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Foto Profil
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _userProfile?['user']['foto_profil'] != null
                                ? _buildImageFromBase64(_userProfile!['user']['foto_profil']) // Tampilkan foto profil dari Base64
                                : null, // Jika foto profil null, backgroundImage akan null
                            child: _userProfile?['user']['foto_profil'] == null
                                ? const Icon(Icons.person, size: 50) // Ikon default jika foto profil tidak ada
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_userProfile?['user']['nama']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                '${_userProfile?['user']['email']}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        leading: const Icon(Icons.account_circle_outlined),
                        title: const Text('Profile saya'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                userProfile: _userProfile!,
                                userToken: widget.userToken,
                              ),
                            ),
                          ).then((isUpdated) {
                            if (isUpdated == true) {
                              _fetchProfile(); // Perbarui data profil setelah edit
                            }
                          });
                          print('Profile saya ditekan');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.history),
                        title: const Text('Riwayat'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistoryScreen(username: widget.username, userToken: widget.userToken),
                            ),
                          );
                          print('Riwayat ditekan');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: const Text('FAQ'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FAQScreen(username: widget.username, userToken: widget.userToken),
                            ),
                          );
                          print('FAQ ditekan');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Keluar'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                          print('Keluar ditekan');
                        },
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(username: widget.username, userToken: widget.userToken),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryScreen(username: widget.username, userToken: widget.userToken),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FAQScreen(username: widget.username, userToken: widget.userToken),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(username: widget.username, userToken: widget.userToken),
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

  // Fungsi untuk mengonversi Base64 ke Image
  ImageProvider _buildImageFromBase64(String base64String) {
    final Uint8List bytes = base64Decode(base64String);
    return MemoryImage(bytes);
  }
}