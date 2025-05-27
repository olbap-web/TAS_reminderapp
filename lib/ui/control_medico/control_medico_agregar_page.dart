import 'package:flutter/material.dart';
import '../../models/control.dart';
import '../../service/control_service.dart';

class AgregarControlPage extends StatefulWidget {
  final int idMascota;

  const AgregarControlPage({super.key, required this.idMascota});

  @override
  State<AgregarControlPage> createState() => _AgregarControlPageState();
}

class _AgregarControlPageState extends State<AgregarControlPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _fechaControl;
  DateTime? _fechaSiguiente;

  final service = ControlMedicoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar Control")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ListTile(
                title: Text(_fechaControl == null
                    ? "Selecciona fecha del control"
                    : "Control: ${_fechaControl!.toLocal()}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final fecha = await _seleccionarFecha();
                  if (fecha != null) setState(() => _fechaControl = fecha);
                },
              ),
              ListTile(
                title: Text(_fechaSiguiente == null
                    ? "Fecha próxima (opcional)"
                    : "Siguiente: ${_fechaSiguiente!.toLocal()}"),
                trailing: const Icon(Icons.calendar_month),
                onTap: () async {
                  final fecha = await _seleccionarFecha();
                  if (fecha != null) setState(() => _fechaSiguiente = fecha);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardar,
                child: const Text("Guardar"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _guardar() async {
    if (_fechaControl == null) return;

    final nuevo = ControlMedico(
      idControl: DateTime.now().millisecondsSinceEpoch,
      idMascota: widget.idMascota,
      fechaRegistro: DateTime.now(),
      fechaControl: _fechaControl!,
      fechaSiguiente: _fechaSiguiente,
      idEstado: 1, // Activo por ejemplo
    );

    await service.agregarControl(nuevo);
    Navigator.pop(context);
  }

  Future<DateTime?> _seleccionarFecha() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2035),
    );
  }
}
