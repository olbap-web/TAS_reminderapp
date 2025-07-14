import 'package:flutter/material.dart';
import 'package:pet_remainder_app/service/control_service.dart';
import 'package:pet_remainder_app/service/treatment_service.dart';
import 'control_medico/control_medico_page.dart';
import 'treatment/treatment_page.dart';

class PetProfilePage extends StatefulWidget {
  final dynamic pet;

  const PetProfilePage({super.key, required this.pet});

  @override
  State<PetProfilePage> createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
  final _ctrlService = MedicalCtrlService();
  final _treatmentService = TreatmentService();

  List<Map<String, dynamic>> controles = [];
  List<Map<String, dynamic>> tratamientos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final idMascota = widget.pet['id_mascota'].toString();

    final ctrl = await _ctrlService.getMedicalCtrlsByPet(idMascota);
    final treat = await _treatmentService.getTreatmentsByPet(idMascota);

    setState(() {
      controles = ctrl.where((c) => c['estado'] == 'Pendiente').toList();
      tratamientos = treat.where((t) => t['estado'] == 'Pendiente').toList();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;

    return Scaffold(
      appBar: AppBar(title: Text(pet['nombre'])),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Especie: ${pet['tipo_mascota']}', style: TextStyle(fontSize: 18)),
                  Text('Sexo: ${pet['sexo']}', style: TextStyle(fontSize: 18)),
                  Text('Fecha de nacimiento: ${pet['fecha_nacimiento']}', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),

                  Text('Controles médicos activos:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...controles.map((c) => ListTile(
                        title: Text('Control del ${c['fecha_control']}'),
                        subtitle: Text(c['estado']),
                      )),

                  TextButton(
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ControlMedicoPage(petId: pet['id_mascota'].toString()),
                      ));
                      await cargarDatos();
                    },
                    child: const Text('Ver historial de controles'),
                  ),

                  const Divider(height: 30),

                  Text('Tratamientos activos:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...tratamientos.map((t) => ListTile(
                        title: Text(t['descripcion'] ?? 'Tratamiento'),
                        subtitle: Text('Desde ${t['fecha_inicio']} hasta ${t['fecha_termino']}'),
                      )),

                  TextButton(
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(
                        builder: (_) => TreatmentPage(petId: pet['id_mascota'].toString()),
                      ));
                      await cargarDatos();
                    },
                    child: const Text('Ver historial de tratamientos'),
                  ),
                ],
              ),
            ),
    );
  }
}
