// class Pet {
//   String name;
//   String breed;
//   String age;
//   String weight;

//   Pet({
//     required this.name,
//     required this.breed,
//     required this.age,
//     required this.weight,
//   });
// }

class Pet {
  final int id;
  final String nombre;
  final String tipo_mascota;
  final String raza;
  final DateTime fechaNacimiento;

  Pet({
    required this.id,
    required this.nombre,
    required this.tipo_mascota,
    required this.raza,
    required this.fechaNacimiento,
  });
}
