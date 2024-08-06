import 'package:recarga_telefonica_flutter/model/telefonia.dart';
import 'cliente.dart';

class Telefono {
  int? id;
  int numero;
  int telefoniaId;
  int clienteId;

  Telefonia? telefonia;
  Cliente? cliente;

  Telefono({
    this.id,
    required this.numero,
    required this.telefoniaId,
    required this.clienteId,
    this.telefonia,
    this.cliente,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numero': numero,
      'telefonia_id': telefoniaId,
      'cliente_id': clienteId,
    };
  }

  factory Telefono.fromMap(Map<String, dynamic> map) {
    return Telefono(
      id: map['id'] as int?,
      numero: map['numero'] as int,
      telefoniaId: map['telefonia_id'] as int,
      clienteId: map['cliente_id'] as int,
    );
  }
}
