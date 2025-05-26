import 'package:flutter/material.dart';
import 'ui/home_page.dart';

void main() {
  runApp(PetReminderApp());
}

class PetReminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Reminder',
      theme: ThemeData(

        useMaterial3: true,
        // primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey)
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
