import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_remainder_app/main.dart';
import 'package:pet_remainder_app/models/pet.dart';
import 'package:pet_remainder_app/service/pet_service.dart';
import 'package:pet_remainder_app/ui/control_medico/control_medico_page.dart';
import 'package:pet_remainder_app/ui/treatment/treatment_page.dart';
import 'user/register_page.dart';
import 'remainder/reminder_page.dart';

import 'package:pet_remainder_app/service/user_service.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDrawerLeft = false;
  bool get isDarkMode => PetReminderApp.themeNotifier.value == ThemeMode.dark;

  final List<Map<String, dynamic>> drawerItems = [];

  List<Pet> pets = [];
  Pet? selectedPet;


  final user = FirebaseAuth.instance.currentUser;
    

  // void requestNotificationPermission() async {
  //   if (await Permission.notification.isDenied) {
  //     await Permission.notification.request();
  //   }
  // }
  @override
  void initState() {
    super.initState();



    // requestNotificationPermission();

    if(user == null){
      //RETORNAR A LOGIN
      FirebaseAuth.instance.signOut();
      GoogleSignIn().signOut();
      FlutterSecureStorage().delete(key: 'jwt');
    }else if (user!.email != null){
      getPersonaByEmail(user!.email!);
    }

    
    pets = PetService.getAllPets();
    if (pets.isNotEmpty) selectedPet = pets.first;

    
  }
  Future<void> getPersonaByEmail(String email) async {
    final userData = await UserService().getPersonaByEmail(email);

    if (userData != null) {
      print("Datos desde BFF: $userData");
      final storage = FlutterSecureStorage();
      await storage.write(key: 'user_data', value: jsonEncode(userData));
    } else {
      // Redirigir al formulario de registro
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RegisterPage()),
        );
      });
    }
  }

  Widget buildDrawerContent(dynamic user) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blueAccent),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (user.photoURL != null)
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.photoURL!),
              ),
              // Icon(Icons.pets, size: 40, color: Colors.white),
              SizedBox(height: 20),
              Text(user.displayName ?? "Sin nombre", style: TextStyle(color: Colors.white, fontSize: 20)),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.pets),
          title: Text('Mis Compañeros'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ReminderPage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.alarm),
          title: Text('Recordatorios'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ReminderPage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.medical_services),
          title: Text('Tratamientos'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => TratamientoPage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.event_note),
          title: Text('Eventos Médicos'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => ControlMedicoPage(idMascota: selectedPet?.id ?? 0)));
          },
        ),
        ListTile(
          leading: Icon(Icons.brightness_6),
          title: Text(isDarkMode ? 'Modo Claro' : 'Modo Oscuro'),
          onTap: () {
            PetReminderApp.themeNotifier.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
            Navigator.pop(context);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.swap_horiz),
          title: Text('Cambiar menú de lado'),
          onTap: () {
            setState(() {
              isDrawerLeft = !isDrawerLeft;
            });
          },
          
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Cerrar sesión'),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
            await FlutterSecureStorage().delete(key: 'jwt');
            Navigator.pop(context);
          },
          
        ),
      ],
    );
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VetCompanion'),
      ),
      drawer: isDrawerLeft ? Drawer(child: buildDrawerContent(user)) : null,
      endDrawer: !isDrawerLeft ? Drawer(child: buildDrawerContent(user)) : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Selecciona una mascota:", style: TextStyle(fontSize: 18)),
            
            Divider(),
            SizedBox(height: 20),

            

          ],
        ),
      ),
    );
  }
}
