import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_remainder_app/main.dart';
import 'package:pet_remainder_app/service/family_group_service.dart';
import 'package:pet_remainder_app/service/pet_service.dart';
import 'package:pet_remainder_app/service/user_service.dart';
import 'package:pet_remainder_app/ui/user/family_group_page.dart';
import 'package:pet_remainder_app/ui/user/register_page.dart';
import 'package:pet_remainder_app/ui/remainder/reminder_page.dart';
import 'package:pet_remainder_app/ui/login_page.dart';
import 'pet_profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDrawerLeft = false;
  bool get isDarkMode => PetReminderApp.themeNotifier.value == ThemeMode.dark;

  final user = FirebaseAuth.instance.currentUser;
  final fgService = FamilyGroupService();
  final petService = PetService();
  final secureStorage = FlutterSecureStorage();

  List<Map<String, dynamic>> familyGroups = [];
  dynamic selectedFamilyGroup;
  List<Map<String, dynamic>> pets = [];

  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _tipoController = TextEditingController();
  final _sexoController = TextEditingController();
  DateTime? _fechaNacimiento;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => isLoading = true);

    final userData = await UserService().getPersonaByEmail(user!.email!);
    if (userData == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => RegisterPage()),
        );
      });
      return;
    }

    await secureStorage.write(key: 'user_data', value: jsonEncode(userData));
    await _loadFamilyGroups(userData['id_persona']);

    setState(() => isLoading = false);
  }

  Future<void> _loadFamilyGroups(String idPersona) async {
    final groups = await fgService.getFamilyGroupByPersona(idPersona);
    setState(() {
      familyGroups = groups;
      if (groups.isNotEmpty) {
        selectedFamilyGroup = groups.first;
      }
    });
    if (groups.isNotEmpty) {
      await _loadPetsByGroup(groups.first['id']);
    }
  }

  Future<void> _loadPetsByGroup(dynamic groupId) async {
    final groupPets = await petService.getPetsByFamilyGroup(groupId.toString());
    setState(() {
      pets = groupPets;
    });
  }

  Future<void> _logoutAndRedirect() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await secureStorage.deleteAll();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
        (route) => false,
      );
    }
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
              if (user?.photoURL != null)
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user!.photoURL!),
                ),
              SizedBox(height: 20),
              Text(user?.displayName ?? "Sin nombre",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ],
          ),
        ),
        // ListTile(
        //   leading: Icon(Icons.pets),
        //   title: Text('Mis Compañeros'),
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (_) => ReminderPage()),
        //     ).then((_) => _loadUserData());
        //   },
        // ),
        ListTile(
          leading: Icon(Icons.alarm),
          title: Text('Recordatorios'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ReminderPage()),
            ).then((_) => _loadUserData());
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
          leading: Icon(Icons.brightness_6),
          title: Text(isDarkMode ? 'Modo Claro' : 'Modo Oscuro'),
          onTap: () {
            PetReminderApp.themeNotifier.value =
                isDarkMode ? ThemeMode.light : ThemeMode.dark;
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Cerrar sesión'),
          onTap: () async {
            await _logoutAndRedirect();
          },
        ),
      ],
    );
  }

  Widget buildFamilyGroupSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Selecciona un grupo familiar:", style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        DropdownButton<dynamic>(
          isExpanded: true,
          value: selectedFamilyGroup,
          items: familyGroups.map((group) {
            return DropdownMenuItem<dynamic>(
              value: group,
              child: Text(group['nombre_grupo_familiar'] ?? 'Sin nombre'),
            );
          }).toList(),
          onChanged: (group) {
            setState(() {
              selectedFamilyGroup = group;
              pets.clear();
            });
            _loadPetsByGroup(group['id']);
          },
        ),
      ],
    );
  }

  void _showCreatePetModal() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Nueva Mascota"),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: "Nombre"),
                  validator: (val) => val!.isEmpty ? "Requerido" : null,
                ),
                TextFormField(
                  controller: _tipoController,
                  decoration: InputDecoration(labelText: "Tipo (Perro, Gato...)"),
                ),
                TextFormField(
                  controller: _sexoController,
                  decoration: InputDecoration(labelText: "Sexo (Macho, Hembra)"),
                ),
                TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2020),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        _fechaNacimiento = date;
                      });
                    }
                  },
                  child: Text(
                    _fechaNacimiento == null
                        ? "Seleccionar fecha de nacimiento"
                        : _fechaNacimiento!.toLocal().toString().split(' ')[0],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              if (_fechaNacimiento == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Por favor selecciona una fecha de nacimiento.")),
                );
                return;
              }

              final fechaNacimientoInt = int.parse(
                "${_fechaNacimiento!.year}${_fechaNacimiento!.month.toString().padLeft(2, '0')}${_fechaNacimiento!.day.toString().padLeft(2, '0')}",
              );

              final success = await petService.createPet(
                idGrupoFamiliar: selectedFamilyGroup['id'],
                nombre: _nombreController.text.trim(),
                tipoMascota: _tipoController.text.trim(),
                sexo: _sexoController.text.trim(),
                fechaNacimiento: fechaNacimientoInt,
              );

              if (success) {
                Navigator.pop(context);
                _nombreController.clear();
                _tipoController.clear();
                _sexoController.clear();
                _fechaNacimiento = null;
                _loadPetsByGroup(selectedFamilyGroup['id']);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error al guardar mascota.")),
                );
              }
            },
            child: Text("Guardar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  Widget buildPetListTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (pets.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text("Este grupo no posee mascotas.", style: TextStyle(color: Colors.grey)),
          )
        else
          ...pets.map((pet) {
            return Card(
              child: ListTile(
                title: Text(pet['nombre'] ?? 'Sin nombre'),
                subtitle: Text("${pet['tipo_mascota']} - ${pet['sexo']}"),
                onTap: () async {
                  await secureStorage.write(key: 'selected_pet', value: jsonEncode(pet));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PetProfilePage(pet: pet)),
                  ).then((_) => _loadUserData());
                },
              ),
            );
          }).toList(),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _showCreatePetModal,
          child: Text("Agregar nueva mascota"),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasGroups = familyGroups.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text('VetCompanion')),
      drawer: isDrawerLeft ? Drawer(child: buildDrawerContent()) : null,
      endDrawer: !isDrawerLeft ? Drawer(child: buildDrawerContent()) : null,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: hasGroups
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildFamilyGroupSelector(),
                          SizedBox(height: 20),
                          Text("Mascotas del grupo:", style: TextStyle(fontSize: 18)),
                          SizedBox(height: 10),
                          buildPetListTable(),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        "No tienes ningún grupo familiar asociado.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FamilyGroupManagerPage()),
          ).then((_) => _loadUserData());
        },
        child: Icon(Icons.group_add),
        tooltip: "Agregar grupo familiar",
      ),
    );
  }
}
