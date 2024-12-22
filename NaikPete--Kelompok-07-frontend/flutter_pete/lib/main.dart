import 'package:flutter/material.dart';
import 'package:flutter_pete/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NaikPete',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const AuthScreen(),
    );
  }
}
