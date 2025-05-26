// import 'package:flutter/material.dart';
// import 'reminder_page.dart';
// import 'pet_profile_page.dart';

// class HomePage extends StatefulWidget {
//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _index = 0;

//   final List<Widget> _pages = [
//     ReminderPage(),
//     PetProfilePage(),
//   ];

//   @override
//   Widget build(BuildContext context) {

//     /**
//      * Aqui el items (apps) lo podria obtener de una bdd 
//      * -estados
//      */
    
//     List<BottomNavigationBarItem> items = const [
//       BottomNavigationBarItem(
//         icon: Icon(Icons.notifications), 
//         label: 'Alertas',
        
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.pets), 
//         label: 'Mascota',
        
//       ),
//       // BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Historial'),

//     ];


//     return Scaffold(
      
//       appBar: AppBar(
//         title: Text(
//           'Pet Reminder',
//           style: TextStyle(
//             color: Colors.blue
//           )
//         ),
//       ),

//       body: _pages[_index],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _index,
//         onTap: (newIndex) => setState(() => _index = newIndex),
//         items: items,
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import '../service/pet_service.dart';
// import '../models/pet.dart';
// import 'pet_profile_page.dart';

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final pets = PetService.getAllPets();

//     return Scaffold(
//       appBar: AppBar(title: Text('Mis Mascotas')),
//       body: ListView.builder(
//         itemCount: pets.length,
//         itemBuilder: (context, index) {
//           final pet = pets[index];
//           return ListTile(
//             title: Text(pet.nombre),
//             subtitle: Text('${pet.especie} - ${pet.raza}'),
//             trailing: Icon(Icons.arrow_forward_ios),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => PetProfilePage(pet: pet)),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:pet_remainder_app/models/pet.dart';
import 'pet_profile_page.dart';
import 'reminder_page.dart';
// Importa otras páginas si las tienes creadas
// import 'treatment_page.dart';
// import 'medical_event_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veterinaria App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.pets, size: 40, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Menú Principal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
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
                  MaterialPageRoute(builder: (context) => PetProfilePage(pet: Pet(id: 2, nombre: 'Misu', especie: 'Gato', raza: 'Siames', fechaNacimiento: DateTime(2021, 5, 18)))),
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
                // Navigator.push(context, MaterialPageRoute(builder: (context) => TreatmentPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.event_note),
              title: Text('Eventos Médicos'),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalEventPage()));
              },
            ),
            Divider(),
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
