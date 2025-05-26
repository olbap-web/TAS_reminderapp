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
  final String especie;
  final String raza;
  final DateTime fechaNacimiento;

  Pet({
    required this.id,
    required this.nombre,
    required this.especie,
    required this.raza,
    required this.fechaNacimiento,
  });
}
