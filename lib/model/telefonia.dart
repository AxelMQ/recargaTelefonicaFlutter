class Telefonia {
  int? id;
  String nombre;
  double comision;
  double saldo;
  int telefono;

  Telefonia({
    this.id,
    required this.nombre,
    required this.comision,
    required this.saldo,
    required this.telefono,
  });

  Telefonia copyWith({
    int? id,
    required String nombre,
    required double comision,
    required double saldo,
    required int telefono,
  }) {
    return Telefonia(
      id: id ?? this.id,
      nombre: nombre,
      comision: comision,
      saldo: saldo,
      telefono: telefono,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'comision': comision,
      'saldo': saldo,
      'telefono': telefono,
    };
  }

  factory Telefonia.fromMap(Map<String, dynamic> map) {
    return Telefonia(
      id: map['id']as int?,
      nombre: map['nombre'] as String? ?? '',
       comision: (map['comision'] as num?)?.toDouble() ?? 0.0,
    saldo: (map['saldo'] as num?)?.toDouble() ?? 0.0,      
    telefono: map['telefono'] as int? ?? 0,
  );
  }
}
