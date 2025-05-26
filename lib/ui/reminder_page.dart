// import 'package:flutter/material.dart';
// import '../models/reminder.dart';

// class ReminderPage extends StatefulWidget {
//   @override
//   State<ReminderPage> createState() => _RemindersPageState();
// }

// class _RemindersPageState extends State<ReminderPage> {
//   final List<Reminder> _reminders = [];

//   final _controller = TextEditingController();

//   void _addReminder() {
//     if (_controller.text.isEmpty){
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Debes seleccionar un tipo de recordatorio(cita medica, remedio, seleccionar mascota, etc.)')
          
//         )
//       );
//       return;
//     }

//     final reminder = Reminder(
//       title: _controller.text,
//       time: DateTime.now().add(Duration(seconds: 5)), // prueba
//     );

//     setState(() => _reminders.add(reminder));
//     _controller.clear();

//     // Aquí puedes activar una notificación programada
//   }

//   @override
//   Widget build(BuildContext context) {

//     final List<Reminder> _reminders = [];

//     /**obtenemos los tipos de la bdd (HTTP) */

//     final List<String> _reminderOptions = [
//       'Cita médica',
//       'Medicamento',
//       'Vacuna',
//       'Seleccionar mascota',
//     ];

//     String? _selectedReminder;

//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         children: [
//            DropdownButtonFormField<String>(
//             value: _selectedReminder,
//             hint: Text('Selecciona un tipo de recordatorio'),
//             decoration: InputDecoration(
//               labelText: 'Tipo de recordatorio',
//               border: OutlineInputBorder(),
//             ),
//             items: _reminderOptions.map((option) {
//               return DropdownMenuItem<String>(
//                 value: option,
//                 child: Text(option),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedReminder = value;
//               });
//             },
//           ),
//           TextField(
//             controller: _controller,
//             decoration: InputDecoration(
//               labelText: 'Medicamento o cita',
//               // suffixIcon: IconButton(
//               //   icon: Icon(Icons.add),
//               //   onPressed: _addReminder,
//               // ),
//             ),
//           ),
//           TextField(
//             controller: _controller,
//             decoration: InputDecoration(
//               labelText: 'Medicamento o cita',
//               // suffixIcon: IconButton(
//               //   icon: Icon(Icons.add),
//               //   onPressed: _addReminder,
//               // ),
//             ),
//           ),
//           SizedBox(height: 16),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _reminders.length,
//               itemBuilder: (context, index) {
//                 final reminder = _reminders[index];
//                 return Card(
//                   child: ListTile(
//                     title: Text(reminder.title),
//                     subtitle: Text(reminder.time.toString()),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//___________________-

// lib/ui/reminder_page.dart
import 'package:flutter/material.dart';
import '../models/reminder.dart';
import '../service/reminder_service.dart';
// ignore: depend_on_referenced_packages
// import 'package:intl/intl.dart';

class ReminderPage extends StatelessWidget {
  final ReminderService reminderService = ReminderService();



  // ignore: slash_for_doc_comments
  /**
   * List String<> veterinarias = Arrays.asList(
    "Dr. Pet",
    "Gpet",
    "Clínica Veterinaria San Bernardo",
    "Veterinaria Vet Company",
    "Oftaderm",
    "Clínica Veterinaria San Damián",
    "Movilvet Urgencias Veterinarias",
    "Centro Quirúrgico Especialidades Veterinarias Hannover",
    "Veterinaria Exótica",
    "InfoVeterinarias.cl",
    "InfoClinicasVeterinarias.cl"
);
   */
  @override
  Widget build(BuildContext context) {
    final List<Reminder> reminders = reminderService.getReminders();

    return Scaffold(
      appBar: AppBar(
        title: Text('Recordatorios'),
      ),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              leading: Icon(
                reminder.title.isNotEmpty? Icons.check_circle : Icons.access_time,
                color: reminder.title.isNotEmpty? Colors.green : Colors.orange,
              ),
              title: Text(reminder.title),
              subtitle: Text(
                'Fecha: ${reminder.time}',
              ),
              trailing: reminder.title.isNotEmpty
                  ? Text("Completado", style: TextStyle(color: Colors.green))
                  : Text("Pendiente", style: TextStyle(color: Colors.red)),
            ),
          );
        },
      ),
    );
  }
}



