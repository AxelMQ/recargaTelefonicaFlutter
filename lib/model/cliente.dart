class Cliente {
  int? id;
  String nombre;

  Cliente({
    this.id,
    required this.nombre,
  });

  Cliente copyWith({
    int? id,
    String? nombre,
  }) {
    return Cliente(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'] as int?,
      nombre: map['nombre']  as String? ?? '',
    );
  }
}
