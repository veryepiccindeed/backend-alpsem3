import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'http://127.0.0.1:8000/api'; // Ganti dengan URL API Anda
  String? token;

  // Method untuk mengambil token dari SharedPreferences
  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  // Method untuk logout
  Future<http.Response> logout(String token) async {
    final response = await http.post(
      Uri.parse('$_url/logout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }

  // Method untuk GET request
  Future<http.Response> getData(String apiURL) async {
    await _getToken(); // Ambil token sebelum melakukan permintaan
    var fullUrl = Uri.parse('$_url$apiURL');
    return await http.get(
      fullUrl,
      headers: _setHeaders(),
    );
  }

  // Method untuk POST request
  Future<http.Response> postData(String apiURL, Map<String, dynamic> data) async {
    await _getToken(); // Ambil token sebelum melakukan permintaan
    var fullUrl = Uri.parse('$_url$apiURL');
    return await http.post(
      fullUrl,
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  // Method untuk PUT request dengan file upload
  Future<http.Response> putData(String endpoint, {required Map<String, String> body, Uint8List? fileBytes}) async {
    await _getToken(); // Ambil token sebelum melakukan permintaan
    final uri = Uri.parse('$_url$endpoint');
    final request = http.MultipartRequest('PUT', uri);

    // Tambahkan header
    request.headers.addAll(_setHeaders());

    // Tambahkan body
    request.fields.addAll(body);

    // Tambahkan file jika ada
    if (fileBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'profile_photo',
        fileBytes,
        filename: 'profile.jpg', // Nama file (opsional)
      ));
    }

    final response = await request.send();
    return http.Response.fromStream(response);
  }

  // Method untuk mengatur headers
  Map<String, String> _setHeaders() {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token', // Tambahkan token jika ada
    };
  }
}