class Telefono {
  int? id;
  int numero;
  int telefoniaId;
  int clienteId;

  Telefono({
    this.id,
    required this.numero,
    required this.telefoniaId,
    required this.clienteId,
  });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'numero' : numero,
      'telefonia_id' : telefoniaId,
      'cliente_id' : clienteId,
    };
  }

  factory Telefono.fromMap(Map<String, dynamic> map){
    return Telefono(
      id: map['id'],
      numero: map['numero'],
      telefoniaId: map['telefonia_id'],
      clienteId: map['cliente_id'],
    );
  }
}