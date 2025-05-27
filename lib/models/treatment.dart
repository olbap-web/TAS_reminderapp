class Tratamiento {
  final int idTratamiento;
  final int idMascota;
  final String nombreTratamiento;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String descripcion;

  Tratamiento({
    required this.idTratamiento,
    required this.idMascota,
    required this.nombreTratamiento,
    required this.fechaInicio,
    required this.fechaFin,
    required this.descripcion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_tratamiento': idTratamiento,
      'id_mascota': idMascota,
      'nombre_tratamiento': nombreTratamiento,
      'fecha_inicio': fechaInicio.toIso8601String(),
      'fecha_fin': fechaFin.toIso8601String(),
      'descripcion': descripcion,
    };
  }

  factory Tratamiento.fromMap(Map<String, dynamic> map) {
    return Tratamiento(
      idTratamiento: map['id_tratamiento'],
      idMascota: map['id_mascota'],
      nombreTratamiento: map['nombre_tratamiento'],
      fechaInicio: DateTime.parse(map['fecha_inicio']),
      fechaFin: DateTime.parse(map['fecha_fin']),
      descripcion: map['descripcion'],
    );
  }
}
