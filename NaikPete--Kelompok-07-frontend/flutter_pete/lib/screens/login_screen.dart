import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_pete/screens/forgotpassword.dart';
import 'package:flutter_pete/screens/register_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pete/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for user input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedRole = 'customer'; // Default role
  bool isLoading = false;

  // Function to log in the user

  Future<void> login() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();
  

  // Validate input fields
  if (email.isEmpty || password.isEmpty || selectedRole == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All fields are required!'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    // API endpoint
    const url = 'http://127.0.0.1:8000/api/login';

    // Make POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'role': selectedRole,
      }),
    );

    // Process API response
    final data = jsonDecode(response.body);
    final token = data['token'];
    final user = data['user'];

    if (token != null && user != null) {
      // Mengambil nama pengguna jika ada, atau fallback ke 'Guest'
      final String userName = user['name'];

      // Pindah ke halaman utama (HomeScreen) dengan nama pengguna
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(username: userName), // Pass nama pengguna ke halaman utama
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed, try again.')),
      );
    }

  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('An error occurred. Please check your connection.'),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Icon(Icons.directions_bus, size: 80, color: Colors.cyan),
              const SizedBox(height: 20),
              const Text(
                'Welcome to NaikPete\'',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Login to start your journey',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: const [
                  DropdownMenuItem(value: 'customer', child: Text('Customer')),
                  DropdownMenuItem(value: 'driver', child: Text('Driver')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      onPressed: login,
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                          const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                );
              },
              child: const Text('Forgot Password?', style: TextStyle(color: Colors.cyan)),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Pindah ke halaman registrasi
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  RegisterScreen()),
                );
              },
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.cyan),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
