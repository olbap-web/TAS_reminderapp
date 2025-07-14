import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MedicalCtrlService {
  final String baseUrl = 'https://bff-vetcompanion-218357869562.us-east1.run.app/api/secure';
  final _storage = const FlutterSecureStorage();

  Future<List<Map<String, dynamic>>> getMedicalCtrlsByPet(String petId) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    final response = await http.get(
      Uri.parse('$baseUrl/medical-ctrl/pet?id=$petId'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      print("Error al obtener los controles medicos : ${response.body}");
      return [];
    }
  }

  

  /// Crear un nuevo control medico
  Future<bool> addNewMedicalCtrl({required dynamic medical_ctrl, required String id_mascota}) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    final userDataRaw = await _storage.read(key: 'user_data');

    if (userDataRaw == null) {
      print("No se encontró user_data en secure storage");
      return false;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/medical-ctrl'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "id_mascota": id_mascota,
        "fecha_registro": medical_ctrl['fecha_registro'],
        "fecha_control": medical_ctrl['fecha_control'],
        "fechas_extra": medical_ctrl['fechas_extra'],
        "estado": 1,	
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print("Error al crear control medicor: ${response.body}");
      return false;
    }
  }
  Future<bool> changeStateMedicalCtrl({required dynamic medical_ctrl}) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    final userDataRaw = await _storage.read(key: 'user_data');

    if (userDataRaw == null) {
      print("No se encontró user_data en secure storage");
      return false;
    }

    // final decoded = jsonDecode(userDataRaw);

    final response = await http.post(
      Uri.parse('$baseUrl/medical-ctrl'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "update":1,
        "id_control": medical_ctrl['id'],
        "estado": medical_ctrl['estado'],	
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print("Error al crear control medicor: ${response.body}");
      return false;
    }
  }
  
}
