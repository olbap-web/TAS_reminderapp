import 'package:pet_remainder_app/models/control.dart';

// import '../models/control.dart';

// class ControlService {
//   static final List<Control> _controls = [
//     Control(id: 1,doctor: 'Monserrat Bustamante op 1', estado: 'Activa', fecha: '2025-05-26' , mascota: '1'),
//     Control(id: 2,doctor: 'Monserrat Bustamante op 2', estado: 'Pendiente', fecha: '2025-05-26' , mascota: '1'),
//     Control(id: 3,doctor: 'Monserrat Bustamante op 3', estado: 'Pendiente', fecha: '2025-05-26', mascota: '1' ),
//   ];

//   static List<Control> getAllControls() => _controls;

//   static Control? getDoctorById(int id) =>
//       _controls.firstWhere((pet) => pet.id == id, orElse: () => _controls[1]);
// }

class ControlMedicoService {
  static final List<ControlMedico> _mockData = [];

  Future<List<ControlMedico>> getControlesPorMascota(int idMascota) async {
    return _mockData.where((c) => c.idMascota == idMascota).toList();
  }

  Future<void> agregarControl(ControlMedico control) async {
    _mockData.add(control);
  }
}



// nombre: 'Firulais', especie: 'Perro', raza: 'Labrador', fechaNacimiento: DateTime(2020, 3, 10)
// nombre: 'Misu', especie: 'Gato', raza: 'Siames', fechaNacimiento: DateTime(2021, 5, 18)
// nombre: 'Rocky', especie: 'Perro', raza: 'Bulldog', fechaNacimiento: DateTime(2019, 1, 5)