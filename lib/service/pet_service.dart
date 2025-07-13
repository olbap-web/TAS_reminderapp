import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class PetService {
  final String baseUrl =
      'https://bff-vetcompanion-218357869562.us-east1.run.app/api/secure';

  Future<List<Map<String, dynamic>>> getPetsByFamilyGroup(String groupId) async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();

    final response = await http.get(
      Uri.parse('$baseUrl/pet/family-group?id=$groupId'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      print("Error al obtener mascotas: ${response.body}");
      return [];
    }
  }

  Future<bool> createPet({
    required String idGrupoFamiliar,
    required String nombre,
    required int fechaNacimiento, 
    required String tipoMascota,
    required String sexo,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();

    final response = await http.post(
      Uri.parse('$baseUrl/pet'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_grupo_familiar': idGrupoFamiliar,
        'nombre': nombre,
        'fecha_nacimiento': fechaNacimiento,
        'tipo_mascota': tipoMascota,
        'sexo': sexo,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print("Error al crear mascota: ${response.body}");
      return false;
    }
  }
}
