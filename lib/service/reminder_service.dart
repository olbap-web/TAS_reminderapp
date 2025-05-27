// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/reminder.dart';

// class ReminderService {
//   static const String baseUrl = 'http://10.0.2.2:8080/api/reminders'; // Usa tu IP o dominio real

//   static Future<List<Reminder>> fetchReminders() async {
//     final response = await http.get(Uri.parse(baseUrl));

//     if (response.statusCode == 200) {
//       final List decoded = json.decode(response.body);
//       return decoded.map((json) => Reminder.fromJson(json)).toList();
//     } else {
//       throw Exception('Error al obtener los recordatorios');
//     }
//   }

//   static Future<void> addReminder(Reminder reminder) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(reminder.toJson()),
//     );

//     if (response.statusCode != 201) {
//       throw Exception('Error al crear el recordatorio');
//     }
//   }
// }

//_______________________________________--
// lib/service/reminder_service.dart
// import '../models/reminder.dart';

// class ReminderService {
//   final List<Reminder> _reminders = [
//     Reminder(title: 'Vacuna Rabia', time: DateTime.parse('2025-01-01')),
//     Reminder(title: 'Control general', time: DateTime.now()),
//     Reminder(title: 'Desparasitación', time: DateTime.now(),),
//   ];

//   List<Reminder> getReminders() {
//     return _reminders;
//   }
// }


import '../models/reminder.dart';

class ReminderService {
  final List<Reminder> _reminders = [
    Reminder(id:'1',title: 'Vacuna Rabia', time: DateTime.parse('2025-01-01'), completed:true),
    Reminder(id:'2',title: 'Control general', time: DateTime.now(), completed:false),
    Reminder(id:'3',title: 'Desparasitación', time: DateTime.now(), completed:false),
  ];

  List<Reminder> getReminders({String filter = 'all'}) {
    switch (filter) {
      case 'pending':
        return _reminders.where((r) => !r.completed).toList();
      case 'completed':
        return _reminders.where((r) => r.completed).toList();
      default:
        return List.from(_reminders);
    }
  }

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
  }

  void toggleReminder(String id) {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reminders[index] = _reminders[index].copyWith(
        completed: !_reminders[index].completed,
      );
    }
  }
}
