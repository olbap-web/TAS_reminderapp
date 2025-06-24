import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _secureStorage = FlutterSecureStorage();
  bool _loading = false;
  String? _error;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() {
          _loading = false;
        });
        return; // El usuario canceló
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // Enviar el ID token al BFF
      final idToken = googleAuth.idToken;
      final jwt = await _getJwtFromBackend(idToken!);

      if (jwt != null) {
        await _secureStorage.write(key: 'jwt', value: jwt);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      } else {
        setState(() {
          _error = "Error al autenticar con el backend";
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error: ${e.toString()}";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<String?> _getJwtFromBackend(String idToken) async {
    final response = await http.post(
      Uri.parse('https://tu-backend.com/api/auth/google'), // ⚠️ cambia esto
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['jwt'];
    } else {
      print("Error BFF: ${response.body}");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pets, size: 80, color: Colors.blueGrey),
              SizedBox(height: 20),
              Text('VetCompanion',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Inicia sesión con Google para continuar',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 30),
              _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                      ),
                      icon: Icon(Icons.login, color: Colors.white),
                      label: Text("Iniciar sesión con Google",
                          style: TextStyle(color: Colors.white)),
                      onPressed: _signInWithGoogle,
                    ),
              if (_error != null) ...[
                SizedBox(height: 20),
                Text(_error!,
                    style: TextStyle(color: Colors.redAccent, fontSize: 14)),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
