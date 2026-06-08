import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  static String? token;
  static int? userId;
  static String? userRole;
  static String? userName;
  static String? userEmail;

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  static Future<dynamic> getResources() async {
    final response = await http.get(
      Uri.parse('$baseUrl/resources'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getResource(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/resources/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> buyResource(int resourceId, int quantity) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions/buy'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'resource_id': resourceId, 'quantity': quantity}),
    );
    return jsonDecode(response.body);
  }

  static Future<dynamic> getTransactions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/transactions'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // ===== UPDATE RESOURCE (Admin Only) =====
  static Future<Map<String, dynamic>> updateResource(
      int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/resources/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  // ===== DELETE RESOURCE (Admin Only) =====
  static Future<Map<String, dynamic>> deleteResource(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/resources/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // ===== OAUTH LOGIN (Google Simulation) =====
  static Future<Map<String, dynamic>> oauthLogin(
      String name, String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/oauth'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email}),
    );
    return jsonDecode(response.body);
  }
}