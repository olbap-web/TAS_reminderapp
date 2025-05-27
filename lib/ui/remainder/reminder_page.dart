import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../models/reminder.dart';
import '../../service/reminder_service.dart';
import 'remainder_add_page.dart';  // Importar la nueva página

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final ReminderService _reminderService = ReminderService();
  String _filter = 'all';

  void _toggleReminder(String id) {
    setState(() {
      _reminderService.toggleReminder(id);
    });
  }

  void _changeFilter(String filter) {
    setState(() {
      _filter = filter;
    });
  }

  void _navigateToAddReminder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddReminderPage(
          onAdd: (reminder) {
            setState(() {
              _reminderService.addReminder(reminder);
            });
            Navigator.pop(context); // Cierra la página AddReminderPage
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Recordatorio "${reminder.title}" agregado'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminders = _reminderService.getReminders(filter: _filter);

    return Scaffold(
      appBar: AppBar(
        title: Text('Recordatorios'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _changeFilter,
            icon: Icon(Icons.filter_list),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'all', child: Text('Todos')),
              PopupMenuItem(value: 'pending', child: Text('Pendientes')),
              PopupMenuItem(value: 'completed', child: Text('Completados')),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              leading: Icon(
                reminder.completed ? Icons.check_circle : Icons.access_time,
                color: reminder.completed ? Colors.green : Colors.orange,
              ),
              title: Text(reminder.title),
              subtitle: Text(
                'Fecha: ${DateFormat('dd/MM/yyyy').format(reminder.time)}',
              ),
              trailing: IconButton(
                icon: Icon(Icons.check),
                color: reminder.completed ? Colors.grey : Colors.blue,
                onPressed: () => _toggleReminder(reminder.id),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddReminder,
        child: const Icon(Icons.add),
      ),
    );
  }
}
