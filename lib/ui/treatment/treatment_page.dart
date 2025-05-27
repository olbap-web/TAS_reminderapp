import 'package:flutter/material.dart';
import 'package:pet_remainder_app/service/pet_service.dart';
import '../../models/pet.dart';
import '../../models/treatment.dart';
import '../../service/treatment_service.dart';
import 'treatment_add_page.dart';

class TratamientoPage extends StatefulWidget {
  const TratamientoPage({super.key});

  @override
  State<TratamientoPage> createState() => _TratamientoPageState();
}

class _TratamientoPageState extends State<TratamientoPage> {
  final tratamientoService = TratamientoService();
  final petService = PetService();

  // Mascotas simuladas
  final List<Pet> mascotas = PetService.getAllPets();

  Pet? mascotaSeleccionada;
  List<Tratamiento> tratamientos = [];

  void _cargarTratamientos() async {
    if (mascotaSeleccionada == null) return;
    final data = await tratamientoService.obtenerPorMascota(mascotaSeleccionada!.id);
    setState(() => tratamientos = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tratamientos por Mascota")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<Pet>(
              hint: const Text("Selecciona una mascota"),
              value: mascotaSeleccionada,
              onChanged: (Pet? nueva) {
                setState(() {
                  mascotaSeleccionada = nueva;
                  tratamientos = [];
                });
                _cargarTratamientos();
              },
              items: mascotas.map((m) {
                return DropdownMenuItem(
                  value: m,
                  child: Text(m.nombre),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: mascotaSeleccionada == null
                  ? const Center(child: Text("Selecciona una mascota para ver tratamientos"))
                  : tratamientos.isEmpty
                      ? const Center(child: Text("No hay tratamientos registrados"))
                      : ListView.builder(
                          itemCount: tratamientos.length,
                          itemBuilder: (context, index) {
                            final t = tratamientos[index];
                            return ListTile(
                              title: Text(t.nombreTratamiento),
                              subtitle: Text("Desde ${t.fechaInicio.toLocal().toString().split(' ')[0]} "
                                  "hasta ${t.fechaFin.toLocal().toString().split(' ')[0]}"),
                            );
                          },
                        ),
            )
          ],
        ),
      ),
      floatingActionButton: mascotaSeleccionada != null
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AgregarTratamientoPage(mascota: mascotaSeleccionada!),
                  ),
                );
                _cargarTratamientos();
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
