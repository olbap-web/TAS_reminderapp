import 'package:flutter/material.dart';
import 'package:pet_remainder_app/service/treatment_service.dart';
import 'package:pet_remainder_app/ui/treatment/treatment_detail_page.dart';

class TreatmentPage extends StatefulWidget {
  final String petId;

  const TreatmentPage({super.key, required this.petId});

  @override
  State<TreatmentPage> createState() => _TreatmentPageState();
}

class _TreatmentPageState extends State<TreatmentPage> {
  final _service = TreatmentService();
  List<Map<String, dynamic>> tratamientos = [];
  bool loading = true;
  int? cargandoIndex;

  @override
  void initState() {
    super.initState();
    cargarTratamientos();
  }

  Future<void> cargarTratamientos() async {
    final data = await _service.getTreatmentsByPet(widget.petId);
    setState(() {
      tratamientos = data;
      loading = false;
    });
  }

  String formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _crearNuevoTratamiento() async {
    final formKey = GlobalKey<FormState>();

    DateTime fechaInicio = DateTime.now();
    DateTime fechaTermino = fechaInicio.add(const Duration(days: 7));
    DateTime fechaAsignacion = DateTime.now();
    String descripcion = '';

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateModal) => AlertDialog(
          title: const Text("Nuevo Tratamiento"),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _datePickerTile("Fecha de inicio", fechaInicio, (picked) {
                    setStateModal(() => fechaInicio = picked);
                  }),
                  _datePickerTile("Fecha de término", fechaTermino, (picked) {
                    setStateModal(() => fechaTermino = picked);
                  }),
                  _datePickerTile("Fecha de asignación", fechaAsignacion, (picked) {
                    setStateModal(() => fechaAsignacion = picked);
                  }),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Descripción"),
                    onChanged: (val) => descripcion = val,
                    validator: (val) => val == null || val.isEmpty ? "Campo requerido" : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text("Guardar"),
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                final nuevo = {
                  'id_mascota': widget.petId,
                  'fecha_inicio': formatDate(fechaInicio),
                  'fecha_termino': formatDate(fechaTermino),
                  'fecha_asignacion': formatDate(fechaAsignacion),
                  'descripcion': descripcion,
                };

                final ok = await _service.addNewTreatment(treatment: nuevo);
                if (ok && context.mounted) {
                  Navigator.of(context).pop();
                  cargarTratamientos();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tratamiento creado')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _datePickerTile(String label, DateTime value, Function(DateTime) onPicked) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(formatDate(value)),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onPicked(picked);
        }
      },
    );
  }

  Future<void> _cambiarEstado(int index) async {
    setState(() => cargandoIndex = index);

    final t = tratamientos[index];
    final nuevoEstado = t['estado'] == 'Pendiente' ? 2 : 1;
    t['estado'] = nuevoEstado;

    final ok = await _service.changeStatueTreatment(treatment: t);
    await cargarTratamientos();

    setState(() => cargandoIndex = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Historial de Tratamientos")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : tratamientos.isEmpty
              ? const Center(child: Text("No hay tratamientos registrados"))
              : ListView.builder(
                  itemCount: tratamientos.length,
                  itemBuilder: (_, i) {
                    final t = tratamientos[i];
                    return Card(
                      child: ListTile(
                        title: Text(t['descripcion'] ?? 'Tratamiento'),
                        subtitle: Text('Inicio: ${t['fecha_inicio']} - Fin: ${t['fecha_termino']}'),
                        trailing: cargandoIndex == i
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : IconButton(
                                icon: Icon(
                                  t['estado'] == 'Completo'
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: t['estado'] == 'Pendiente' ? Colors.green : Colors.grey,
                                ),
                                onPressed: () => _cambiarEstado(i),
                              ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TreatmentDetailPage(treatment: t),
                            ),
                          );
                          await cargarTratamientos();
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearNuevoTratamiento,
        child: const Icon(Icons.add),
        tooltip: 'Nuevo tratamiento',
      ),
    );
  }
}
