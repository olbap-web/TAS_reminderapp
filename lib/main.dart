
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_remainder_app/ui/auth_gate.dart';
import 'package:pet_remainder_app/ui/login_page.dart';
import 'ui/home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa la zona horaria
  // tz.initializeTimeZones();
  // tz.setLocalLocation(tz.getLocation('America/Santiago')); // Ajusta según tu país

  // // Inicializa las notificaciones
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('@mipmap/ic_launcher');

  // final InitializationSettings initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  // );

  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);


  WidgetsFlutterBinding.ensureInitialized();

  
  await Firebase.initializeApp(); // Agrega esto

  runApp(PetReminderApp());
}

class PetReminderApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'VetCompanion',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: currentMode,
          home: AuthGate(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
