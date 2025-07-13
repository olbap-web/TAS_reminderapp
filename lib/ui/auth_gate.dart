import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_page.dart';
import 'login_page.dart';
import 'user/register_page.dart';

class AuthGate extends StatelessWidget {
  final storage = FlutterSecureStorage();

  Future<bool> _checkUserInBackend(User user) async {
    final idToken = await user.getIdToken();

    final response = await http.get(
      Uri.parse(
          'https://bff-vetcompanion-218357869562.us-east1.run.app/api/secure/user?email=${user.email}'),
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      // Guardar datos del usuario si quieres
      await storage.write(key: 'user_data', value: response.body);
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final user = snapshot.data;

        if (user == null) return LoginPage();

        // Si hay usuario autenticado, usar FutureBuilder para chequear en el BFF
        return FutureBuilder<bool>(
          future: _checkUserInBackend(user),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('Error verificando usuario en backend'),
                ),
              );
            }

            if (snapshot.data == true) {
              return HomePage();
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Debes completar tu registro')),
                );
              });

              return RegisterPage();
            }
          },
        );
      },
    );
  }
}
