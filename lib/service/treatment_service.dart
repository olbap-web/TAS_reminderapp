import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TreatmentService {
  final String baseUrl = 'https://bff-vetcompanion-218357869562.us-east1.run.app/api/secure';
  final _storage = const FlutterSecureStorage();

  Future<List<Map<String, dynamic>>> getTreatmentsByPet(String petId) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    final response = await http.get(
      Uri.parse('$baseUrl/treatment/pet?id=$petId'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      print("Error al obtener los tratamientos de la mascota : ${response.body}");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getDocumentsByTreatment(String treatmentId) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    final response = await http.get(
      Uri.parse('$baseUrl/treatment/documents?id=$treatmentId'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      print("Error al obtener los documentos del tratamiento : ${response.body}");
      return [];
    }
  }
  Future<List<Map<String, dynamic>>> getMedicineByTreatment(String treatmentId) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    final response = await http.get(
      Uri.parse('$baseUrl/treatment/medicine?id=$treatmentId'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      print("Error al obtener los medicamentos del tratamiento : ${response.body}");
      return [];
    }
  }
  // Future<Map<String, dynamic>> getTreatmentById(String treatmentId) async {
  //   final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

  //   final response = await http.get(
  //     Uri.parse('$baseUrl/treatment/medicine?id=$treatmentId'),
  //     headers: {
  //       'Authorization': 'Bearer $idToken',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     // return <Map<String, dynamic>;
  //   } else {
  //     print("Error al obtener los medicamentos del tratamiento : ${response.body}");
  //     return [];
  //   }
  // }

  /// Crear un nuevo grupo familiar
  Future<bool> addNewTreatment({required dynamic treatment}) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    final userDataRaw = await _storage.read(key: 'user_data');

    if (userDataRaw == null) {
      print("No se encontró user_data en secure storage");
      return false;
    }

    final decoded = jsonDecode(userDataRaw);

    final response = await http.post(
      Uri.parse('$baseUrl/treatment'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "id_mascota": treatment['id_mascota'],
        "fecha_inicio": treatment['fecha_inicio'],
        "fecha_termino": treatment['fecha_termino'],
        "fecha_asignacion": treatment['fecha_asignacion'],
        "descripcion": treatment['descripcion'],
        "estado": 1,	
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print("Error al crear grupo familiar: ${response.body}");
      return false;
    }
  }

  Future<bool> addNewMedicineForTreatment({required String id_medicine, required String id_treatment }) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    final userDataRaw = await _storage.read(key: 'user_data');

    if (userDataRaw == null) {
      print("No se encontró user_data en secure storage");
      return false;
    }

    final decoded = jsonDecode(userDataRaw);

    final response = await http.post(
      Uri.parse('$baseUrl/treatment'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "id_tratamiento": id_treatment,
        "id_medicamento": id_medicine,
        "medicamento":1,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print("Error al registrar nuevo medicamento: ${response.body}");
      return false;
    }
  }
  Future<bool> changeStatueTreatment({required dynamic treatment }) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    final userDataRaw = await _storage.read(key: 'user_data');

    if (userDataRaw == null) {
      print("No se encontró user_data en secure storage");
      return false;
    }

    final decoded = jsonDecode(userDataRaw);

    final response = await http.post(
      Uri.parse('$baseUrl/treatment'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "id_tratamiento": treatment['id'],
        "estado":treatment['estado'],
        "update":1,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print("Error al registrar nuevo medicamento: ${response.body}");
      return false;
    }
  }

  Future<bool> addDocumentForTreatment({required dynamic document, required int id_treatment }) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    final userDataRaw = await _storage.read(key: 'user_data');

    if (userDataRaw == null) {
      print("No se encontró user_data en secure storage");
      return false;
    }

    final decoded = jsonDecode(userDataRaw);

    final response = await http.post(
      Uri.parse('$baseUrl/treatment'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "ruta_documento":document['ruta'],
        "nombre_documento":document['nombre'],
        "id_tratamiento": id_treatment,
        "documento":1,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print("Error al registrar nuevo medicamento: ${response.body}");
      return false;
    }
  }

  Future<bool> deactivateMedicine({required int id_medicine, required int id_treatment, required int estado }) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    final userDataRaw = await _storage.read(key: 'user_data');

    if (userDataRaw == null) {
      print("No se encontró user_data en secure storage");
      return false;
    }

    final decoded = jsonDecode(userDataRaw);

    final response = await http.post(
      Uri.parse('$baseUrl/treatment'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "id_tratamiento": id_treatment,
        "id_medicamento": id_medicine,
        "estado":estado,
        "medicamento":1,
        "update":1,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print("Error al registrar nuevo medicamento: ${response.body}");
      return false;
    }
  }
}
