// // servicios/mascota_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class Mascota {
//   final int id;
//   final String nombre;
//   final String especie;

//   Mascota({required this.id, required this.nombre, required this.especie});

//   factory Mascota.fromJson(Map<String, dynamic> json) {
//     return Mascota(
//       id: json['id'],
//       nombre: json['nombre'],
//       especie: json['especie'],
//     );
//   }
// }

// class MascotaService {
//   final String baseUrl = 'http://tu-servidor:puerto/api/mascotas';

//   Future<List<Mascota>> obtenerMascotas() async {
//     final respuesta = await http.get(Uri.parse(baseUrl));

//     if (respuesta.statusCode == 200) {
//       List jsonResponse = json.decode(respuesta.body);
//       return jsonResponse.map((e) => Mascota.fromJson(e)).toList();
//     } else {
//       throw Exception('Error al cargar mascotas');
//     }
//   }
// }

import '../models/pet.dart';

class PetService {
  static final List<Pet> _pets = [
    Pet(id: 1, nombre: 'Firulais', especie: 'Perro', raza: 'Labrador', fechaNacimiento: DateTime(2020, 3, 10)),
    Pet(id: 2, nombre: 'Misu', especie: 'Gato', raza: 'Siames', fechaNacimiento: DateTime(2021, 5, 18)),
    Pet(id: 3, nombre: 'Rocky', especie: 'Perro', raza: 'Bulldog', fechaNacimiento: DateTime(2019, 1, 5)),
  ];

  static List<Pet> getAllPets() => _pets;

  static Pet? getPetById(int id) =>
      _pets.firstWhere((pet) => pet.id == id, orElse: () => Pet(id: id, nombre: 'sas', especie: 'especie', raza: 'raza', fechaNacimiento: DateTime(DateTime.now().year)));
}
