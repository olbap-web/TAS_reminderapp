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

import 'package:flutter/material.dart';
import '../service/pet_service.dart';
import '../models/pet.dart';
import 'pet_profile_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pets = PetService.getAllPets();

    return Scaffold(
      appBar: AppBar(title: Text('Mis Mascotas')),
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final pet = pets[index];
          return ListTile(
            title: Text(pet.nombre),
            subtitle: Text('${pet.especie} - ${pet.raza}'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PetProfilePage(pet: pet)),
              );
            },
          );
        },
      ),
    );
  }
}
