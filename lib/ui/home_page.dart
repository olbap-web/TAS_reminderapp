import 'package:flutter/material.dart';
import 'package:pet_remainder_app/main.dart';
import 'package:pet_remainder_app/models/pet.dart';
import 'package:pet_remainder_app/service/pet_service.dart';
import 'package:pet_remainder_app/ui/control_medico/control_medico_page.dart';
import 'package:pet_remainder_app/ui/treatment/treatment_page.dart';
import 'pet_profile_page.dart';
import 'remainder/reminder_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDrawerLeft = true;
  bool get isDarkMode => PetReminderApp.themeNotifier.value == ThemeMode.dark;

  final List<Map<String, dynamic>> drawerItems = [];

  List<Pet> pets = [];
  Pet? selectedPet;

  @override
  void initState() {
    super.initState();
    pets = PetService.getAllPets();
    if (pets.isNotEmpty) selectedPet = pets.first;

    drawerItems.addAll([
      {
        'icon': Icons.alarm,
        'title': 'Recordatorios',
        'action': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReminderPage()),
            ),
      },
      {
        'icon': Icons.medical_services,
        'title': 'Tratamientos',
        'action': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TratamientoPage()),
            ),
      },
      {
        'icon': Icons.event_note,
        'title': 'Eventos Médicos',
        'action': () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ControlMedicoPage(idMascota: selectedPet?.id ?? 0)),
            ),
      },
      {
        'icon': Icons.brightness_6,
        'title': () => isDarkMode ? 'Modo Claro' : 'Modo Oscuro',
        'action': () {
          PetReminderApp.themeNotifier.value =
              isDarkMode ? ThemeMode.light : ThemeMode.dark;
          Navigator.pop(context);
        },
      },
      {
        'icon': Icons.logout,
        'title': 'Cerrar sesión',
        'action': () {
          Navigator.pop(context);
        },
      },
    ]);
  }

  Widget buildDrawerContent() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blueAccent),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.pets, size: 40, color: Colors.white),
              SizedBox(height: 10),
              Text('Home', style: TextStyle(color: Colors.white, fontSize: 20)),
            ],
          ),
        ),
        ...drawerItems.map((item) {
          final icon = item['icon'];
          final title = item['title'];
          final action = item['action'];
          return ListTile(
            leading: Icon(icon),
            title: Text(title is Function ? title() : title),
            onTap: action,
          );
        }).toList(),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VetCompanion'),
      ),
      drawer: isDrawerLeft ? Drawer(child: buildDrawerContent()) : null,
      endDrawer: !isDrawerLeft ? Drawer(child: buildDrawerContent()) : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Selecciona una mascota:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            DropdownButton<Pet>(
              value: selectedPet,
              hint: Text('Elige una mascota'),
              isExpanded: true,
              onChanged: (Pet? newPet) {
                setState(() {
                  selectedPet = newPet;
                });
              },
              items: pets.map((Pet pet) {
                return DropdownMenuItem<Pet>(
                  value: pet,
                  child: Text(pet.nombre),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            if (selectedPet != null) ...[
              Text("Información del perfil:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Nombre: ${selectedPet!.nombre}"),
              Text("Especie: ${selectedPet!.especie}"),
              Text("Raza: ${selectedPet!.raza}"),
              Text("Fecha de nacimiento: ${selectedPet!.fechaNacimiento.toLocal().toString().split(' ')[0]}"),
            ],
            Divider(),
            SizedBox(height: 20),

            

          ],
        ),
      ),
    );
  }
}
