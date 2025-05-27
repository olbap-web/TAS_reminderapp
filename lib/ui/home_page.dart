


// import 'package:flutter/material.dart';
// import 'package:pet_remainder_app/models/pet.dart';
// import 'package:pet_remainder_app/ui/control_medico/control_medico_page.dart';
// import 'pet_profile_page.dart';
// import 'remainder/reminder_page.dart';
// // Importa otras páginas si las tienes creadas
// // import 'treatment_page.dart';
// // import 'medical_event_page.dart';

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Veterinaria App'),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blueAccent,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(Icons.pets, size: 40, color: Colors.white),
//                   SizedBox(height: 10),
//                   Text(
//                     'Menú Principal',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.pets),
//               title: Text('Perfil de mascota'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => PetProfilePage(pet: Pet(id: 2, nombre: 'Misu', especie: 'Gato', raza: 'Siames', fechaNacimiento: DateTime(2021, 5, 18)))),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.alarm),
//               title: Text('Recordatorios'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ReminderPage()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.medical_services),
//               title: Text('Tratamientos'),
//               onTap: () {
//                 // Navigator.push(context, MaterialPageRoute(builder: (context) => TreatmentPage()));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.event_note),
//               title: Text('Eventos Médicos'),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => ControlMedicoPage(idMascota: 2,)));
//               },
//             ),
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Cerrar sesión'),
//               onTap: () {
//                 Navigator.pop(context);
//                 // Lógica para cerrar sesión si aplica
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Center(
//         child: Text('Bienvenido a la app de la veterinaria'),
//       ),
//     );
//   }
// }
// ///_____________________________________
// ///
//import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:pet_remainder_app/main.dart'; // Importa el main para acceder al themeNotifier
import 'package:pet_remainder_app/models/pet.dart';
import 'package:pet_remainder_app/ui/control_medico/control_medico_page.dart';
import 'package:pet_remainder_app/ui/treatment/treatment_page.dart';
import 'pet_profile_page.dart';
import 'remainder/reminder_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = PetReminderApp.themeNotifier.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Veterinaria App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.pets, size: 40, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Menú Principal',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.pets),
              title: Text('Perfil de mascota'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetProfilePage(
                      pet: Pet(
                        id: 2,
                        nombre: 'Misu',
                        especie: 'Gato',
                        raza: 'Siames',
                        fechaNacimiento: DateTime(2021, 5, 18),
                      ),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Recordatorios'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReminderPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.medical_services),
              title: Text('Tratamientos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TratamientoPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.event_note),
              title: Text('Eventos Médicos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ControlMedicoPage(idMascota: 2)),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.brightness_6),
              title: Text(isDarkMode ? 'Modo Claro' : 'Modo Oscuro'),
              onTap: () {
                PetReminderApp.themeNotifier.value =
                    isDarkMode ? ThemeMode.light : ThemeMode.dark;
                Navigator.pop(context); // Cierra el Drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar sesión'),
              onTap: () {
                Navigator.pop(context);
                // Lógica para cerrar sesión si aplica
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Bienvenido a la app de la veterinaria'),
      ),
    );
  }
}
