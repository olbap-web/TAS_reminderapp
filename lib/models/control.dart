class ControlMedico {
  final int idControl;
  final int idMascota;
  final DateTime fechaRegistro;
  final DateTime fechaControl;
  final DateTime? fechaSiguiente;
  final int idEstado;

  ControlMedico({
    required this.idControl,
    required this.idMascota,
    required this.fechaRegistro,
    required this.fechaControl,
    this.fechaSiguiente,
    required this.idEstado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_control': idControl,
      'id_mascota': idMascota,
      'fecha_registro': fechaRegistro.toIso8601String(),
      'fecha_control': fechaControl.toIso8601String(),
      'fecha_siguiente': fechaSiguiente?.toIso8601String(),
      'id_estado': idEstado,
    };
  }

  factory ControlMedico.fromMap(Map<String, dynamic> map) {
    return ControlMedico(
      idControl: map['id_control'],
      idMascota: map['id_mascota'],
      fechaRegistro: DateTime.parse(map['fecha_registro']),
      fechaControl: DateTime.parse(map['fecha_control']),
      fechaSiguiente: map['fecha_siguiente'] != null
          ? DateTime.parse(map['fecha_siguiente'])
          : null,
      idEstado: map['id_estado'],
    );
  }
}
