class CodigoUSSD {
  final int? id;
  final String codigo;
  final String? descripcion;
  final int telefoniaId;

  CodigoUSSD({
    this.id,
    required this.codigo,
    this.descripcion,
    required this.telefoniaId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codigo': codigo,
      'descripcion': descripcion,
      'telefonia_id': telefoniaId,
    };
  }

  factory CodigoUSSD.fromMap(Map<String, dynamic> map) {
    return CodigoUSSD(
      id: map['id'],
      codigo: map['codigo'],
      descripcion: map['descripcion'],
      telefoniaId: map['telefonia_id'],
    );
  }

  CodigoUSSD copyWith({
    int? id,
    String? codigo,
    String? descripcion,
    int? telefoniaId,
  }) {
    return CodigoUSSD(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      descripcion: descripcion ?? this.descripcion,
      telefoniaId: telefoniaId ?? this.telefoniaId,
    );
  }
}
