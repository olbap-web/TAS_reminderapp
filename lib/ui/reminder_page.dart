import 'package:flutter/material.dart';
import '../models/reminder.dart';

class ReminderPage extends StatefulWidget {
  @override
  State<ReminderPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<ReminderPage> {
  final List<Reminder> _reminders = [];

  final _controller = TextEditingController();

  void _addReminder() {
    if (_controller.text.isEmpty) return;

    final reminder = Reminder(
      title: _controller.text,
      time: DateTime.now().add(Duration(seconds: 5)), // prueba
    );

    setState(() => _reminders.add(reminder));
    _controller.clear();

    // Aquí puedes activar una notificación programada
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Medicamento o cita',
              suffixIcon: IconButton(
                icon: Icon(Icons.add),
                onPressed: _addReminder,
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _reminders.length,
              itemBuilder: (context, index) {
                final reminder = _reminders[index];
                return Card(
                  child: ListTile(
                    title: Text(reminder.title),
                    subtitle: Text(reminder.time.toString()),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
