import 'package:recarga_telefonica_flutter/model/telefonia.dart';
import 'package:recarga_telefonica_flutter/model/telefono.dart';
import 'cliente.dart';

class Recarga {
  int? id;
  double monto;
  DateTime fecha;
  String estado;
  String tipoRecarga;
  int telefonoId;
  int clienteId;

  Telefono? telefono;
  Cliente? cliente;
  Telefonia? telefonia;

  Recarga({
    this.id,
    required this.monto,
    required this.fecha,
    required this.estado,
    required this.tipoRecarga,
    required this.telefonoId,
    required this.clienteId,
    this.telefono,
    this.cliente,
    this.telefonia,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'monto': monto,
      'fecha': fecha.toIso8601String(), //conv DateTime a String
      'estado': estado,
      'tipo_recarga': tipoRecarga,
      'telefono_id': telefonoId,
      'cliente_id': clienteId,
    };
  }

  factory Recarga.fromMap(Map<String, dynamic> map) {
    return Recarga(
      id: map['id'],
      monto: map['monto'],
      fecha: DateTime.parse(map['fecha'] as String),
      estado: map['estado'],
      tipoRecarga: map['tipo_recarga'],
      telefonoId: map['telefono_id'],
      clienteId: map['cliente_id'],
    );
  }
}
