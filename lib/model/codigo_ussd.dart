class CodigoUSSD {
  int? id;
  String codigo;
  String descripcion;
  int telefoniaId;

  CodigoUSSD({
    this.id,
    required this.codigo,
    required this.descripcion,
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
      codigo: map['codigo'],
      descripcion: map['descripcion'],
      telefoniaId: map['telefoniaId'],
    );
  }
}
