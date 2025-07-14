import 'package:flutter/material.dart';
import 'package:pet_remainder_app/service/control_service.dart';

class ControlMedicoPage extends StatefulWidget {
  final String petId;

  const ControlMedicoPage({super.key, required this.petId});

  @override
  State<ControlMedicoPage> createState() => _ControlMedicoPageState();
}

class _ControlMedicoPageState extends State<ControlMedicoPage> {
  final _service = MedicalCtrlService();
  List<Map<String, dynamic>> controles = [];
  bool loading = true;
  int? cargandoControl;

  @override
  void initState() {
    super.initState();
    cargarControles();
  }

  Future<void> cargarControles() async {
    final data = await _service.getMedicalCtrlsByPet(widget.petId);
    setState(() {
      controles = data;
      loading = false;
    });
  }

  String formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _crearNuevoControl() async {
    final formKey = GlobalKey<FormState>();
    DateTime fechaControl = DateTime.now();
    String fechasExtra = '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nuevo control médico"),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Fecha del control"),
                  subtitle: Text(formatDate(fechaControl)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: fechaControl,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      fechaControl = picked;
                      (context as Element).markNeedsBuild();
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Observaciones"),
                  onChanged: (val) => fechasExtra = val,
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
              final nuevoControl = {
                'fecha_registro': formatDate(DateTime.now()),
                'fecha_control': formatDate(fechaControl),
                'fechas_extra': fechasExtra.isNotEmpty ? fechasExtra : null,
              };

              final ok = await _service.addNewMedicalCtrl(
                medical_ctrl: nuevoControl,
                id_mascota: widget.petId,
              );

              if (ok && context.mounted) {
                Navigator.of(context).pop();
                cargarControles();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Control creado con éxito')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _cambiarEstado(int index) async {
    setState(() => cargandoControl = index);

    final control = controles[index];
    final nuevoEstado = control['estado'] == 'Pendiente' ? 2 : 1;
    control['estado'] = nuevoEstado;

    final ok = await _service.changeStateMedicalCtrl(medical_ctrl: control);
    await cargarControles();

    setState(() => cargandoControl = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Historial Médico")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : controles.isEmpty
              ? const Center(child: Text("No hay controles médicos registrados"))
              : ListView.builder(
                  itemCount: controles.length,
                  itemBuilder: (_, i) {
                    final ctrl = controles[i];
                    return Card(
                      child: ListTile(
                        title: Text('Control del ${ctrl['fecha_control']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Estado: ${ctrl['estado']}'),
                            if (ctrl['fechas_extra'] != null && ctrl['fechas_extra'].toString().isNotEmpty)
                              Text('Descripción: ${ctrl['fechas_extra']}'),
                          ],
                        ),
                        trailing: cargandoControl == i
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : IconButton(
                                icon: Icon(
                                  ctrl['estado'] == 'Completo'
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: ctrl['estado'] == 'Pendiente' ? Colors.green : Colors.grey,
                                ),
                                onPressed: () => _cambiarEstado(i),
                              ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearNuevoControl,
        child: const Icon(Icons.add),
        tooltip: 'Nuevo control médico',
      ),
    );
  }
}
