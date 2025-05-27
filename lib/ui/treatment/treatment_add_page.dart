import 'package:flutter/material.dart';
import '../../models/pet.dart';
import '../../models/treatment.dart';
import '../../service/treatment_service.dart';

class AgregarTratamientoPage extends StatefulWidget {
  final Pet mascota;

  const AgregarTratamientoPage({super.key, required this.mascota});

  @override
  State<AgregarTratamientoPage> createState() => _AgregarTratamientoPageState();
}

class _AgregarTratamientoPageState extends State<AgregarTratamientoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _descripcionCtrl = TextEditingController();
  DateTime? _inicio;
  DateTime? _fin;

  final servicio = TratamientoService();

  Future<DateTime?> _seleccionarFecha(DateTime initial) {
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
  }

  Future<void> _guardar() async {
    if (_formKey.currentState?.validate() != true || _inicio == null || _fin == null) return;

    final nuevo = Tratamiento(
      idTratamiento: DateTime.now().millisecondsSinceEpoch,
      idMascota: widget.mascota.id,
      nombreTratamiento: _nombreCtrl.text,
      descripcion: _descripcionCtrl.text,
      fechaInicio: _inicio!,
      fechaFin: _fin!,
    );

    await servicio.agregar(nuevo);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Tratamiento")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: "Nombre del tratamiento"),
                validator: (val) => val == null || val.isEmpty ? "Requerido" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descripcionCtrl,
                decoration: const InputDecoration(labelText: "Descripción"),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(_inicio == null ? "Fecha de inicio" : "Inicio: ${_inicio!.toLocal()}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final fecha = await _seleccionarFecha(DateTime.now());
                  if (fecha != null) setState(() => _inicio = fecha);
                },
              ),
              ListTile(
                title: Text(_fin == null ? "Fecha de fin" : "Fin: ${_fin!.toLocal()}"),
                trailing: const Icon(Icons.calendar_month),
                onTap: () async {
                  final fecha = await _seleccionarFecha(_inicio ?? DateTime.now());
                  if (fecha != null) setState(() => _fin = fecha);
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
}
