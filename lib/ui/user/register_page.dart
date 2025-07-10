import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _rutController = TextEditingController();

  bool _isLoading = false;

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    final idToken = await user?.getIdToken();

    if (idToken == null) return;

    final Map<String, dynamic> newUser = {
      'nombre': _nombreController.text.trim(),
      'apellido': _apellidoController.text.trim(),
      'rut': _rutController.text.trim(),
      'email': user!.email,
    };

    final response = await http.post(
      Uri.parse('https://bff-vetcompanion-218357869562.us-east1.run.app/api/user'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(newUser),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 201) {
      final storage = FlutterSecureStorage();
      await storage.write(key: 'user_data', value: jsonEncode(newUser));

      Navigator.pop(context); // Vuelve al home_page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar usuario')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa tu nombre' : null,
              ),
              TextFormField(
                controller: _apellidoController,
                decoration: InputDecoration(labelText: 'Apellido'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa tu apellido' : null,
              ),
              TextFormField(
                controller: _rutController,
                decoration: InputDecoration(labelText: 'RUT'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa tu RUT' : null,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _registerUser,
                      child: Text('Registrarse'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
