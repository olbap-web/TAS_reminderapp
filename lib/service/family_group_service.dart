import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class FamilyGroupService {
  final String baseUrl = 'https://bff-vetcompanion-218357869562.us-east1.run.app/api/secure';
  final _storage = const FlutterSecureStorage();

  /// Obtener grupos familiares por ID de persona
  Future<List<Map<String, dynamic>>> getFamilyGroupByPersona(String personaId) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    final response = await http.get(
      Uri.parse('$baseUrl/family-group/persona?id=$personaId'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      print("Error al obtener grupos familiares: ${response.body}");
      return [];
    }
  }

  /// Obtener miembros de un grupo familiar
  Future<List<Map<String, dynamic>>> getMembersByGroupId(String groupId) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    final response = await http.get(
      Uri.parse('$baseUrl/family-group/members?id=$groupId'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      print("Error al obtener miembros del grupo: ${response.body}");
      return [];
    }
  }

  /// Salir de un grupo familiar
  Future<bool> leaveFamilyGroup({required String groupId}) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    final userDataRaw = await _storage.read(key: 'user_data');

    if (userDataRaw == null) {
      print("No se encontró user_data en secure storage");
      return false;
    }

    final decoded = jsonDecode(userDataRaw);

    final response = await http.delete(
      Uri.parse('$baseUrl/family-group'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_grupo': groupId,
        'id_persona': decoded['id_persona'],
        'estado': "0",
        'update': 1,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Error al salir del grupo: ${response.body}");
      return false;
    }
  }

  /// Crear un nuevo grupo familiar
  Future<bool> addNewFamilyGroup({required String nombre_grupo}) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    final userDataRaw = await _storage.read(key: 'user_data');

    if (userDataRaw == null) {
      print("No se encontró user_data en secure storage");
      return false;
    }

    final decoded = jsonDecode(userDataRaw);

    final response = await http.post(
      Uri.parse('$baseUrl/family-group'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'new': 1,
        'id_persona': decoded['id_persona'],
        'nombre_grupo': nombre_grupo,
        'lider': decoded['id_persona'],
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print("Error al crear grupo familiar: ${response.body}");
      return false;
    }
  }
  Future<bool> addNewMember({
    required String email,
    required String groupId 
    }) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    final userDataRaw = await _storage.read(key: 'user_data');

    if (userDataRaw == null) {
      print("No se encontró user_data en secure storage");
      return false;
    }

    final decoded = jsonDecode(userDataRaw);

    final response = await http.post(
      Uri.parse('$baseUrl/family-group'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'persona': 1,
        'id_grupo':groupId,
        'email': email,
        'lider': decoded['id_persona'],
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print("Error al crear grupo familiar: ${response.body}");
      return false;
    }
  }
}
