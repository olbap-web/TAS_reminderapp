import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reminder.dart';

class ReminderService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/reminders'; // Usa tu IP o dominio real

  static Future<List<Reminder>> fetchReminders() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List decoded = json.decode(response.body);
      return decoded.map((json) => Reminder.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los recordatorios');
    }
  }

  static Future<void> addReminder(Reminder reminder) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reminder.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear el recordatorio');
    }
  }
}
