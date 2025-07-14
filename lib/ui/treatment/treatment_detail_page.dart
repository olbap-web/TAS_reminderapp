import 'package:flutter/material.dart';
import 'package:pet_remainder_app/service/treatment_service.dart';
import 'package:pet_remainder_app/service/medicine_service.dart';

class TreatmentDetailPage extends StatefulWidget {
  final Map<String, dynamic> treatment;

  const TreatmentDetailPage({super.key, required this.treatment});

  @override
  State<TreatmentDetailPage> createState() => _TreatmentDetailPageState();
}

class _TreatmentDetailPageState extends State<TreatmentDetailPage> {
  final _treatmentService = TreatmentService();
  final _medService = MedicineService();

  List<Map<String, dynamic>> medicamentos = [];
  List<Map<String, dynamic>> documentos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final idTratamiento = widget.treatment['id'].toString();

    final meds = await _treatmentService.getMedicineByTreatment(idTratamiento);
    final docs = await _treatmentService.getDocumentsByTreatment(idTratamiento);

    setState(() {
      medicamentos = meds;
      documentos = docs;
      loading = false;
    });
  }

  Future<void> _agregarMedicamento() async {
    final disponibles = await _medService
        .getMedicineNotInTreatment(widget.treatment['id'].toString());

    if (disponibles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay medicamentos disponibles para asociar")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: disponibles.length,
        itemBuilder: (_, i) {
          final med = disponibles[i];
          return ListTile(
            title: Text(med['nombre']),
            subtitle: Text(med['descripcion'] ?? ''),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final ok = await _treatmentService.addNewMedicineForTreatment(
                  id_medicine: med['id_medicamento'],
                  id_treatment: widget.treatment['id'],
                );
                if (ok) {
                  Navigator.pop(context);
                  await cargarDatos();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Medicamento agregado: ${med['nombre']}")),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _desactivarMedicamento(Map<String, dynamic> med) async {
    final ok = await _treatmentService.deactivateMedicine(
      id_medicine: med['id_medicamento'],
      id_treatment: widget.treatment['id'],
      estado: 0, // Desactivado
    );
    if (ok) await cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.treatment;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tratamiento #${t['id']}'),
        actions: [
          IconButton(
            onPressed: _agregarMedicamento,
            icon: const Icon(Icons.medical_services),
            tooltip: 'Agregar medicamento',
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Descripción: ${t['descripcion'] ?? ''}', style: const TextStyle(fontSize: 16)),
                  Text('Inicio: ${t['fecha_inicio']}', style: const TextStyle(fontSize: 16)),
                  Text('Término: ${t['fecha_termino']}', style: const TextStyle(fontSize: 16)),
                  Text('Estado: ${t['estado']}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  const Divider(),
                  const Text("Medicamentos asociados", style: TextStyle(fontWeight: FontWeight.bold)),
                  ...medicamentos.map((m) => Card(
                        child: ListTile(
                          title: Text(m['nombre']),
                          subtitle: Text(m['descripcion'] ?? ''),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _desactivarMedicamento(m),
                          ),
                        ),
                      )),
                  const SizedBox(height: 20),
                  const Divider(),
                  const Text("Documentos asociados", style: TextStyle(fontWeight: FontWeight.bold)),
                  ...documentos.map((d) => Card(
                        child: ListTile(
                          title: Text(d['nombre_documento'] ?? 'Sin nombre'),
                          subtitle: Text(d['ruta_documento'] ?? ''),
                          leading: const Icon(Icons.insert_drive_file),
                        ),
                      )),
                ],
              ),
            ),
    );
  }
}
