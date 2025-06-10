
import 'package:flutter/material.dart';
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
          home: HomePage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
