import 'dart:convert';
import 'package:flutter_pete/models/userProfile.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api'; // Replace with your API base URL
  final String token; // User's authentication token

  ApiService({required this.token});

  Future<UserProfile> fetchProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return UserProfile.fromJson(data['user']);
    } else {
      throw Exception('Failed to load profile');
    }
  }
}