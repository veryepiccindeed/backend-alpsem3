import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'http://127.0.0.1:8000/api';
  String? token;

  Future<void> _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var savedToken = localStorage.getString('token');
    if (savedToken != null) {
      token = jsonDecode(savedToken)['token'];
    }
  }

  Future<http.Response> auth(Map<String, dynamic> data, String apiURL) async {
    var fullUrl = Uri.parse('$_url$apiURL');
    return await http.post(
      fullUrl,
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  Future<http.Response> getData(String apiURL) async {
    var fullUrl = Uri.parse('$_url$apiURL');
    await _getToken();
    return await http.get(
      fullUrl,
      headers: _setHeaders(),
    );
  }

  Map<String, String> _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
}
