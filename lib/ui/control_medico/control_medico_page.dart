import 'package:flutter/material.dart';
import '../../models/control.dart';
import '../../service/control_service.dart';
import 'control_medico_agregar_page.dart';

class ControlMedicoPage extends StatefulWidget {
  final int idMascota;

  const ControlMedicoPage({super.key, required this.idMascota});

  @override
  State<ControlMedicoPage> createState() => _ControlMedicoPageState();
}

class _ControlMedicoPageState extends State<ControlMedicoPage> {
  final service = ControlMedicoService();
  late Future<List<ControlMedico>> controles;

  @override
  void initState() {
    super.initState();
    controles = service.getControlesPorMascota(widget.idMascota);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Controles Médicos")),
      body: FutureBuilder(
        future: controles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(child: Text("No hay controles registrados."));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final control = data[index];
              return ListTile(
                leading: const Icon(Icons.medical_services),
                title: Text("Control: ${control.fechaControl.toLocal()}"),
                subtitle: Text("Próximo: ${control.fechaSiguiente?.toLocal() ?? 'No definido'}"),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AgregarControlPage(idMascota: widget.idMascota),
            ),
          );
          setState(() {
            controles = service.getControlesPorMascota(widget.idMascota);
          });
        },
      ),
    );
  }
}
