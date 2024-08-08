class Cliente {
  int? id;
  String nombre;
  double deuda;

  Cliente({
    this.id,
    required this.nombre,
    this.deuda = 0.0,
  });

  Cliente copyWith({
    int? id,
    String? nombre,
    double? deuda,
  }) {
    return Cliente(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      deuda: deuda ?? this.deuda,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'deuda': deuda, 
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'] as int?,
      nombre: map['nombre']  as String? ?? '',
      deuda: map['deuda'] as double? ?? 0.0,
    );
  }
}
