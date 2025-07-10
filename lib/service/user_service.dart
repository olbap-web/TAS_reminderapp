import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  final String baseUrl = 'https://bff-vetcompanion-218357869562.us-east1.run.app/api'; // ⬅️ tu URL real

  Future<Map<String, dynamic>?> getUserFromBFF(String email) async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();

    if (idToken == null) return null;

    // print("${email}");

    final response = await http.get(
      Uri.parse('$baseUrl/user?email=$email'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error BFF: ${response.body}");
      return null;
    }
  }
  Future<Map<String, dynamic>?> getPersonaByEmail(String email) async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();

    if (idToken == null) return null;

    // print("${email}");

    final response = await http.get(
      Uri.parse('$baseUrl/user?email=$email'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    }  else {
      print("Error BFF: ${response.body} - ${response.statusCode} ");
      return null;
    }
  }
}
