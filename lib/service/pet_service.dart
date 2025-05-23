// servicios/mascota_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class Mascota {
  final int id;
  final String nombre;
  final String especie;

  Mascota({required this.id, required this.nombre, required this.especie});

  factory Mascota.fromJson(Map<String, dynamic> json) {
    return Mascota(
      id: json['id'],
      nombre: json['nombre'],
      especie: json['especie'],
    );
  }
}

class MascotaService {
  final String baseUrl = 'http://tu-servidor:puerto/api/mascotas';

  Future<List<Mascota>> obtenerMascotas() async {
    final respuesta = await http.get(Uri.parse(baseUrl));

    if (respuesta.statusCode == 200) {
      List jsonResponse = json.decode(respuesta.body);
      return jsonResponse.map((e) => Mascota.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar mascotas');
    }
  }
}
