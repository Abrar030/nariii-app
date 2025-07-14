import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.213.249/api'; // for Android emulator

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, String>> _getHeaders({bool requireAuth = false}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (requireAuth) {
      final token = await getToken();
      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception('Login failed: ${response.statusCode} - ${response.body}');
    }

    final responseBody = jsonDecode(response.body);
    final token = responseBody['token'] as String?;
    if (token == null) {
      throw Exception('Login successful, but token not found in response.');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    return true;
  }

  static Future<bool> register(String fullName, String email, String phone, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Registration failed: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<bool> addContact(String name, String email, String phone, String relation) async {
    final headers = await _getHeaders(requireAuth: true);
    final response = await http.post(
      Uri.parse('$baseUrl/contacts/'),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'relationship': relation,
        'notify': true
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to add contact: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getContacts() async {
    final headers = await _getHeaders(requireAuth: true);
    final response = await http.get(
      Uri.parse('$baseUrl/contacts/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> decodedBody = jsonDecode(response.body);
      return decodedBody.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load contacts: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<String?> triggerSOS(String location) async {
    final headers = await _getHeaders(requireAuth: true);
    final response = await http.post(
      Uri.parse('$baseUrl/sos/trigger'),
      headers: headers,
      body: jsonEncode({'location': location}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['sos_id'].toString();
    } else {
      throw Exception('Failed to trigger SOS: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<bool> uploadSOSMedia(String sosId, File file) async {
    final token = await getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/sos/upload'),
    );

    if (token == null) {
      throw Exception('Authentication token not found for SOS media upload.');
    }
    request.headers['Authorization'] = 'Bearer $token'; // MultipartRequest headers are set directly
    request.fields['sos_id'] = sosId;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamedResponse = await request.send();
    if (streamedResponse.statusCode == 200) {
      return true;
    } else {
      final response = await http.Response.fromStream(streamedResponse);
      throw Exception('Failed to upload SOS media: ${response.statusCode} - ${response.body}');
    }
  }
}
