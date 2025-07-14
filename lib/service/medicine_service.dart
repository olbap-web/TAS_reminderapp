import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class MedicineService {
  final String baseUrl =
      'https://bff-vetcompanion-218357869562.us-east1.run.app/api/secure';

  Future<List<Map<String, dynamic>>> getMedicineNotInTreatment(String treatmentId) async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();

    final response = await http.get(
      Uri.parse('$baseUrl/medicine/no-treatment?id=$treatmentId'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      print("Error al obtener medicinas: ${response.body}");
      return [];
    }
  }
}
