import 'package:pet_remainder_app/models/control.dart';

// import '../models/control.dart';

class ControlService {
  static final List<Control> _controls = [
    Control(id: 1,doctor: 'Monserrat Bustamante op 5', estado: 'Activa', fecha: '2025-05-26' ),
    Control(id: 2,doctor: 'Monserrat Bustamante op 5', estado: 'Pendiente', fecha: '2025-05-26' ),
    Control(id: 3,doctor: 'Monserrat Bustamante op 5', estado: 'Pendiente', fecha: '2025-05-26' ),
  ];

  static List<Control> getAllControls() => _controls;

  static Control? getDoctorById(int id) =>
      _controls.firstWhere((pet) => pet.id == id, orElse: () => Control(id: 2,doctor: 'Monserrat Bustamante op 5', estado: 'Pendiente', fecha: '2025-05-26' ));
}




// nombre: 'Firulais', especie: 'Perro', raza: 'Labrador', fechaNacimiento: DateTime(2020, 3, 10)
// nombre: 'Misu', especie: 'Gato', raza: 'Siames', fechaNacimiento: DateTime(2021, 5, 18)
// nombre: 'Rocky', especie: 'Perro', raza: 'Bulldog', fechaNacimiento: DateTime(2019, 1, 5)