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
        primarySwatch: Colors.teal,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
