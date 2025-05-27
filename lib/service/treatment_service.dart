
import '../models/treatment.dart';

class TratamientoService {
  static final List<Tratamiento> _tratamientos = [];

  Future<List<Tratamiento>> obtenerPorMascota(int idMascota) async {
    return _tratamientos.where((t) => t.idMascota == idMascota).toList();
  }

  Future<void> agregar(Tratamiento tratamiento) async {
    _tratamientos.add(tratamiento);
  }
}
