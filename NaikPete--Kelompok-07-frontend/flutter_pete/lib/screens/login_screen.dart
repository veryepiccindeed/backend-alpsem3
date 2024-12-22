import 'package:flutter/material.dart';
import 'package:flutter_pete/screens/home_screen.dart';
import '../widgets/custom_textfield.dart'; // Sesuaikan path ini
import 'package:flutter_pete/network/api.dart'; // Sesuaikan path ini
import 'package:flutter_pete/screens/register_screen.dart'; // Sesuaikan path ini
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  bool _secureText = true;
  String? _selectedRole = 'customer'; // Default role adalah customer

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Toggle untuk show/hide password
  void showHidePassword() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  // Menampilkan pesan Snackbar
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Fungsi untuk login
  Future<void> handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final String email = emailController.text;
    final String password = passwordController.text;

    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'role': _selectedRole, // Tambahkan role ke body request
    };

    try {
      print('Sending login request with data: $data');
      final response = await Network().auth(data, '/login'); // Panggil API login
      final body = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: $body');

      if (body.containsKey('success') && body['success'] == true) {
        final SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', json.encode(body['token'] ?? ''));
        localStorage.setString('user', json.encode(body['user'] ?? {}));
        localStorage.setString('role', body['user']['role'] ?? '');

        print('Token saved: ${localStorage.getString('token')}');
        print('User saved: ${localStorage.getString('user')}');

        if (mounted) {
          print('Navigating to HomeScreen...');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(username: body['user']['name']),
            ),
          );
        }
      } else {
        showSnackBar(body['message'] ?? 'Login failed.');
        print('Login failed: ${body['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      showSnackBar('Terjadi kesalahan. Silakan coba lagi.');
      print('Error during login: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.directions_bus, size: 80, color: Colors.cyan),
                  const SizedBox(height: 20),
                  const Text(
                    'Halo, mitra NaikPete',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Yuk, masuk untuk mulai perjalanan',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: 'Email',
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    hintText: 'Kata sandi',
                    isPassword: true,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kata sandi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Dropdown untuk memilih peran
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: const InputDecoration(labelText: 'Pilih Peran'),
                    items: [
                      DropdownMenuItem(value: 'customer', child: Text('Customer')),
                      DropdownMenuItem(value: 'driver', child: Text('Driver')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Peran harus dipilih';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    onPressed: _isLoading ? null : handleLogin,
                    child: Text(
                      _isLoading ? 'Loading...' : 'Masuk',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // TODO: Tambahkan navigasi ke halaman lupa password
                    },
                    child: const Text('Lupa kata sandi?', style: TextStyle(color: Colors.cyan)),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Arahkan ke halaman register_screen.dart
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      'Belum memiliki akun? Daftar',
                      style: TextStyle(color: Colors.cyan),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
