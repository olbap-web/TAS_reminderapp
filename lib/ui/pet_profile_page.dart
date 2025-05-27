// import 'package:flutter/material.dart';

// class PetProfilePage extends StatefulWidget {
//   @override
//   State<PetProfilePage> createState() => _PetProfilePageState();
// }

// class _PetProfilePageState extends State<PetProfilePage> {
//   final _formKey = GlobalKey<FormState>();

//   String _name = '';
//   String _breed = '';
//   String _age = '';
//   String _weight = '';

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(12),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             Text('Ficha de la asw2sada', style: TextStyle(fontSize: 22)),
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Nombre'),
//               onSaved: (val) => _name = val ?? '',
//             ),
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Raza'),
//               onSaved: (val) => _breed = val ?? '',
//             ),
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Edad'),
//               onSaved: (val) => _age = val ?? '',
//             ),
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Peso'),
//               onSaved: (val) => _weight = val ?? '',
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 _formKey.currentState?.save();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Ficha guardada')),
//                 );
//               },
//               child: Text('Guardar ficha'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'remainder/reminder_page.dart';

class PetProfilePage extends StatelessWidget {
  final Pet pet;

  const PetProfilePage({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pet.nombre)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Especie: ${pet.especie}', style: TextStyle(fontSize: 18)),
            Text('Raza: ${pet.raza}', style: TextStyle(fontSize: 18)),
            Text('Fecha de nacimiento: ${pet.fechaNacimiento.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Ver recordatorios'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReminderPage()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Crear recordatorio'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReminderPage()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
