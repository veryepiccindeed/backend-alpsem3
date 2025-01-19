import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'http://127.0.0.1:8000/api';
  String? token;

  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  Future<http.Response> getData(String apiURL) async {
    await _getToken(); // Ambil token sebelum melakukan permintaan
    var fullUrl = Uri.parse('$_url$apiURL');
    return await http.get(
      fullUrl,
      headers: _setHeaders(),
    );
  }

  Future<http.Response> postData(String apiURL, Map<String, dynamic> data) async {
    await _getToken(); // Ambil token sebelum melakukan permintaan
    var fullUrl = Uri.parse('$_url$apiURL');
    return await http.post(
      fullUrl,
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  Map<String, String> _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token', // Tambahkan token jika ada
      };
}