import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_remainder_app/service/family_group_service.dart';
import 'package:pet_remainder_app/service/user_service.dart';

class FamilyGroupManagerPage extends StatefulWidget {
  const FamilyGroupManagerPage({super.key});

  @override
  State<FamilyGroupManagerPage> createState() => _FamilyGroupManagerPageState();
}

class _FamilyGroupManagerPageState extends State<FamilyGroupManagerPage> {
  final fgService = FamilyGroupService();
  final userService = UserService();
  final storage = FlutterSecureStorage();

  List<Map<String, dynamic>> userGroups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserGroups();
  }

  Future<void> _loadUserGroups() async {
    setState(() => isLoading = true);
    final userData = await storage.read(key: 'user_data');
    if (userData != null) {
      final persona = jsonDecode(userData);
      final groups = await fgService.getFamilyGroupByPersona(persona['id_persona']);
      setState(() {
        userGroups = groups;
        isLoading = false;
      });
    }
  }

  Future<void> _showGroupDetails(Map<String, dynamic> group) async {
    final members = await fgService.getMembersByGroupId(group['id']);
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Grupo: ${group['nombre_grupo_familiar']}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Miembros del grupo:"),
            SizedBox(height: 10),
            ...members.map((m) => Text("- ${m['nombre']} ${m['apellido']} (${m['email']})")),
            Divider(),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Agregar miembro por correo"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Ingresa un correo válido.")),
                );
                return;
              }

              final success = await fgService.addNewMember(
                email: email,
                groupId: group['id'].toString(),
              );

              if (success) {
                Navigator.pop(context); // Cierra el diálogo actual
                await _showGroupDetails(group); // Vuelve a abrir el diálogo actualizado
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Miembro $email agregado exitosamente.")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("No se pudo agregar a $email. Verifica si el usuario existe.")),
                );
              }
            },
            child: Text("Agregar miembro"),
          ),
          TextButton(
            onPressed: () async {
              final userData = await storage.read(key: 'user_data');
              if (userData != null) {
                // final persona = jsonDecode(userData);
                await fgService.leaveFamilyGroup(
                  groupId: group['id'].toString(),
                );
                Navigator.pop(context);
                _loadUserGroups();
              }
            },
            child: Text("Salir del grupo", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cerrar"),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupItem(Map<String, dynamic> group) {
    return Card(
      child: ListTile(
        title: Text(group['nombre_grupo_familiar']),
        subtitle: Text("Estado: ${group['estado'] ?? 'Activo'}"),
        onTap: () => _showGroupDetails(group),
      ),
    );
  }

  void _showAddGroupDialog() {
    final groupNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Crear nuevo grupo familiar"),
        content: TextField(
          controller: groupNameController,
          decoration: InputDecoration(labelText: "Nombre del grupo familiar"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              final nombreGrupo = groupNameController.text.trim();
              if (nombreGrupo.isEmpty) return;

              Navigator.pop(context);

              final success = await fgService.addNewFamilyGroup(nombre_grupo:  nombreGrupo);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Grupo '$nombreGrupo' creado exitosamente.")),
                );
                _loadUserGroups();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error al crear el grupo.")),
                );
              }
            },
            child: Text("Agregar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mis Grupos Familiares")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userGroups.isEmpty
              ? Center(child: Text("No estás en ningún grupo familiar."))
              : ListView(
                  padding: EdgeInsets.all(16),
                  children: userGroups.map(_buildGroupItem).toList(),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGroupDialog,
        child: Icon(Icons.group_add),
        tooltip: "Crear nuevo grupo",
      ),
    );
  }
}
