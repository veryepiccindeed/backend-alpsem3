import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat Datang, $username!'),
      ),
      body: Center(
        child: Text(
          'Halo, $username! Selamat menggunakan aplikasi NaikPete.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
