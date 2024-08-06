import 'package:recarga_telefonica_flutter/data/database.dart';
import 'package:recarga_telefonica_flutter/model/recarga.dart';
import 'package:sqflite/sqflite.dart';
import '../model/cliente.dart';
import '../model/telefonia.dart';
import '../model/telefono.dart';

class RecargaDao {
  Future<List<Recarga>> retrieveRecargas() async {
    final Database db = await initializeDB();

    // Consulta con JOIN para obtener los datos relacionados
    final List<Map<String, dynamic>> queryResult = await db.rawQuery('''
      SELECT r.*, t.numero AS telefono_numero, c.nombre AS cliente_nombre, 
             tel.nombre AS telefonia_nombre, tel.comision AS telefonia_comision
      FROM recarga r
      JOIN telefono t ON r.telefono_id = t.id
      JOIN cliente c ON r.cliente_id = c.id
      JOIN telefonia tel ON t.telefonia_id = tel.id
    ''');

    // Asocia los datos recuperados a cada recarga
    return queryResult.map((map) {
      final telefono = Telefono(
        id: map['telefono_id'] as int? ?? 0,
        numero: map['telefono_numero'] as int? ?? 0,
        telefoniaId: map['telefonia_id'] as int? ?? 0,
        clienteId: map['cliente_id'] as int? ?? 0,
      );

      final cliente = Cliente(
        id: map['cliente_id'] as int? ?? 0,
        nombre: map['cliente_nombre'] as String? ?? '',
      );

      final telefonia = Telefonia(
        id: map['telefonia_id'] as int? ?? 0,
        nombre: map['telefonia_nombre'] as String? ?? '',
        comision: map['telefonia_comision'] as double? ?? 0.0,
        saldo: -1,
        telefono: -1,
      );

      return Recarga.fromMap(map)
        ..telefono = telefono
        ..cliente = cliente
        ..telefonia = telefonia;
    }).toList();
  }

  Future<void> insertRecarga(Recarga recarga) async {
    final Database db = await initializeDB();
    await db.insert(
      'recarga',
      recarga.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
