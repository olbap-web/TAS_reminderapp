import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/reminder.dart';
import '../../service/reminder_service.dart';
import 'remainder_add_page.dart';

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
            Navigator.pop(context);// Cierra la página AddReminderPage
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
    // final reminders = _reminderService.getReminders(filter: _filter);

    // // Agrupar recordatorios por fecha
    // final Map<String, List<Reminder>> groupedReminders = {};
    // for (var reminder in reminders) {
    //   final dateKey = DateFormat('MMMM yyyy').format(reminder.time);
    //   groupedReminders.putIfAbsent(dateKey, () => []).add(reminder);
    // }
    final reminders = _reminderService.getReminders(filter: _filter)
      ..sort((a, b) => b.time.compareTo(a.time)); // Orden descendente

    // Agrupar recordatorios por mes (descendente también)
    final Map<String, List<Reminder>> groupedReminders = {};
    for (var reminder in reminders) {
      final dateKey = DateFormat('MMMM yyyy').format(reminder.time);
      groupedReminders.putIfAbsent(dateKey, () => []).add(reminder);
    }

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
      body: groupedReminders.isEmpty
          ? Center(child: Text("No hay recordatorios"))
          : ListView(
              children: groupedReminders.entries.map((entry) {
                final title = entry.key;
                final remindersList = entry.value;

                // Agrupar por día dentro del mes
                final Map<String, List<Reminder>> dayGroups = {};
                
                remindersList.sort((a, b) => b.time.compareTo(a.time)); // también descendente

                for (var r in remindersList) {
                  final dayKey = DateFormat('dd MMMM yyyy').format(r.time);
                  dayGroups.putIfAbsent(dayKey, () => []).add(r);
                }

                return ExpansionTile(
                  title: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: dayGroups.entries.map((dayEntry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            dayEntry.key,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        ...dayEntry.value.map((reminder) {
                          return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            child: ListTile(
                              leading: Icon(
                                reminder.completed
                                    ? Icons.check_circle
                                    : Icons.access_time,
                                color: reminder.completed
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              title: Text(reminder.title),
                              subtitle: Text(
                                'Hora: ${DateFormat('HH:mm').format(reminder.time)}',
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.check),
                                color: reminder.completed
                                    ? Colors.grey
                                    : Colors.blue,
                                onPressed: () => _toggleReminder(reminder.id),
                              ),
                            ),
                          );
                        }).toList()
                      ],
                    );
                  }).toList(),
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddReminder,
        child: const Icon(Icons.add),
      ),
    );
  }
}
