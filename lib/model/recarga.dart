class Recarga{
  int? id;
  double monto;
  DateTime fecha;
  String estado;
  String tipoRecarga;
  int telefonoId;
  int clienteId;

  Recarga({
    this.id,
    required this.monto,
    required this.fecha,
    required this.estado,
    required this.tipoRecarga,
    required this.telefonoId,
    required this.clienteId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'monto' : monto,
      'fecha' : fecha,
      'estado' : estado,
      'tipo_recarga' : tipoRecarga,
      'telefono_id' : telefonoId,
      'cliente_id' : clienteId,
    };
  }

  factory Recarga.fromMap(Map<String, dynamic> map){
    return Recarga(
      id: map['id'],
      monto: map['monto'],
      fecha: map['fecha'],
      estado: map['estado'],
      tipoRecarga: map['tipo_recarga'],
      telefonoId: map['telefono_id'],
      clienteId: map['cliente_id'],
    );
  }
}