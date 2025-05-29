import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:pet_remainder_app/service/notification_service.dart';
import 'package:uuid/uuid.dart';

import '../../models/reminder.dart';

class AddReminderPage extends StatefulWidget {
  final Function(Reminder) onAdd;

  const AddReminderPage({super.key, required this.onAdd});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(), // solo fechas desde hoy
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveReminder() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingresa un título')),
      );
      return;
    }

    final newReminder = Reminder(
      id: const Uuid().v4(),
      title: title,
      time: _selectedDate,
      completed: false,
    );

    // Programar notificación
    // NotificationService.showScheduledNotification(
    //   id: newReminder.hashCode,
    //   title: 'Recordatorio: ${newReminder.title}',
    //   body: '¡Es hora de atender este recordatorio!',
    //   scheduledDate: newReminder.time,
    // );

    widget.onAdd(newReminder);
  }


  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy – HH:mm').format(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Recordatorio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Fecha y hora: $formattedDate',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectDate,
                  child: Text('Seleccionar'),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton.icon(
              onPressed: _saveReminder,
              icon: Icon(Icons.save),
              label: Text('Guardar'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
