import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../home_page.dart';
import '../auth_gate.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _rutController = TextEditingController();

  DateTime? _fechaNacimiento;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _rutController.addListener(() {
      final text = _rutController.text.replaceAll('.', '').replaceAll('-', '');
      if (text.length > 1) {
        final formatted = formatearRUT(text);
        if (_rutController.text != formatted) {
          _rutController.value = _rutController.value.copyWith(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }
      }
    });
  }

  String formatearRUT(String rut) {
    rut = rut.replaceAll(RegExp(r'[^0-9kK]'), '').toUpperCase();
    if (rut.length < 2) return rut;

    String cuerpo = rut.substring(0, rut.length - 1);
    String dv = rut.substring(rut.length - 1);

    final buffer = StringBuffer();
    for (int i = 0; i < cuerpo.length; i++) {
      int pos = cuerpo.length - i;
      buffer.write(cuerpo[i]);
      if (pos > 1 && pos % 3 == 1) buffer.write('.');
    }

    return '${buffer.toString()}-$dv';
  }

  String formatearFecha(DateTime fecha) {
    final year = fecha.year.toString().padLeft(4, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    final day = fecha.day.toString().padLeft(2, '0');
    return '$year$month$day';
  }

  bool validarEdadMinima(DateTime? fechaNacimiento) {
    if (fechaNacimiento == null) return false;
    final hoy = DateTime.now();
    final edad = hoy.year - fechaNacimiento.year;
    final ajustada = hoy.month > fechaNacimiento.month ||
        (hoy.month == fechaNacimiento.month &&
            hoy.day >= fechaNacimiento.day);
    return edad > 16 || (edad == 16 && ajustada);
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    if (!validarEdadMinima(_fechaNacimiento)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debes tener al menos 16 años')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final idToken = await user?.getIdToken();

      if (idToken == null || user?.email == null) {
        throw Exception("Sesión inválida");
      }

      String rutSinFormato =
          _rutController.text.replaceAll('.', '').replaceAll('-', '');
      String rutNumero = rutSinFormato.substring(0, rutSinFormato.length - 1);
      String dv = rutSinFormato.substring(rutSinFormato.length - 1);

      final Map<String, dynamic> newUser = {
        'nombre': _nombreController.text.trim(),
        'apellido': _apellidoController.text.trim(),
        'rut': rutNumero,
        'dv': dv,
        'email': user!.email,
        'fecha_nacimiento': formatearFecha(_fechaNacimiento!),
        'insert_persona':1
      };

      print("enviando petición");
      final response = await http.post(
        Uri.parse(
            'https://bff-vetcompanion-218357869562.us-east1.run.app/api/secure/user'),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(newUser),
      );
      print("recibiendo petición");
      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final storage = FlutterSecureStorage();
        await storage.write(key: 'user_data', value: jsonEncode(newUser));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registro exitoso')),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => AuthGate()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar: ${response.body}')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _seleccionarFechaNacimiento() async {
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Selecciona tu fecha de nacimiento',
    );

    if (seleccionada != null) {
      setState(() {
        _fechaNacimiento = seleccionada;
      });
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
          child: ListView(
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
              SizedBox(height: 16),
              ListTile(
                title: Text(_fechaNacimiento == null
                    ? 'Selecciona fecha de nacimiento'
                    : 'Fecha: ${_fechaNacimiento!.day}/${_fechaNacimiento!.month}/${_fechaNacimiento!.year}'),
                trailing: Icon(Icons.calendar_today),
                onTap: _seleccionarFechaNacimiento,
              ),
              SizedBox(height: 24),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
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
