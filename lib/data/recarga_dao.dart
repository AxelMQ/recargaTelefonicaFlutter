import 'package:recarga_telefonica_flutter/data/database.dart';
import 'package:recarga_telefonica_flutter/model/recarga.dart';
import 'package:sqflite/sqflite.dart';
import '../model/cliente.dart';
import '../model/telefonia.dart';
import '../model/telefono.dart';

class RecargaDao {
  Future<List<Recarga>> retrieveRecargas(
      {String filter = 'todo', int limit = 5, int offset = 0}) async {
    final Database db = await initializeDB();

    // Consulta con JOIN para obtener los datos relacionados
    String query = ('''
      SELECT r.*, t.numero AS telefono_numero, c.nombre AS cliente_nombre, 
             tel.nombre AS telefonia_nombre, tel.comision AS telefonia_comision
      FROM recarga r
      JOIN telefono t ON r.telefono_id = t.id
      JOIN cliente c ON r.cliente_id = c.id
      JOIN telefonia tel ON t.telefonia_id = tel.id
    ''');

    // Añadir una cláusula WHERE si el filtro no es 'todo'
    if (filter != 'todo') {
      query += ' WHERE r.estado = ?';
    }

    // Ordenar por fecha en orden descendente y añadir LIMIT y OFFSET
    query += ' ORDER BY r.fecha DESC LIMIT ? OFFSET ?';

    // Ejecutar la consulta
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(
      query,
      filter != 'todo' ? [filter, limit, offset] : [limit, offset],
    );

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

    // Inicia una transacción para asegurar que ambas operaciones se realicen de manera atómica
    await db.transaction((txn) async {
      // Inserta la recarga
      await txn.insert(
        'recarga',
        recarga.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Actualiza el saldo de la telefonía
      await updateSaldoInTransaction(
          txn, recarga.telefonia!.id!.toInt(), recarga.monto);

      // Actualiza la deuda del cliente solo si el estado de la recarga es "Pendiente"
      if (recarga.estado == 'Pendiente') {
        await updateDeudaInTransaction(txn, recarga.clienteId, recarga.monto);
      }
    });
  }

  Future<void> updateDeudaInTransaction(
      Transaction txn, int clienteId, double monto) async {
    // Obtén la deuda actual del cliente
    final List<Map<String, dynamic>> result = await txn.rawQuery('''
    SELECT deuda
    FROM cliente
    WHERE id = ?
  ''', [clienteId]);

    final deudaActual =
        result.isNotEmpty ? result.first['deuda'] as double : 0.0;

    // Calcula la nueva deuda
    final nuevaDeuda = deudaActual + monto;

    // Actualiza la deuda del cliente
    await txn.update(
      'cliente',
      {'deuda': nuevaDeuda},
      where: 'id = ?',
      whereArgs: [clienteId],
    );
  }

  Future<void> updateSaldoInTransaction(
      Transaction txn, int telefonoId, double monto) async {
    // Obtén el saldo actual de la telefonía
    final List<Map<String, dynamic>> result = await txn.rawQuery('''
    SELECT saldo
    FROM telefonia
    WHERE id = ?
  ''', [telefonoId]);

    final saldoActual =
        result.isNotEmpty ? result.first['saldo'] as double : 0.0;

    // Calcula el nuevo saldo
    final nuevoSaldo = saldoActual - monto;

    // Actualiza el saldo de la telefonía
    await txn.update(
      'telefonia',
      {'saldo': nuevoSaldo},
      where: 'id = ?',
      whereArgs: [telefonoId],
    );
  }

  // Método para recuperar recargas pendientes para un cliente
  Future<List<Recarga>> retrieveRecargasPendientesByCliente(
      int clienteId) async {
    final Database db = await initializeDB();

    // Consulta con JOIN para obtener los datos relacionados
    final List<Map<String, dynamic>> queryResult = await db.rawQuery('''
      SELECT r.*, t.numero AS telefono_numero, c.nombre AS cliente_nombre, 
             tel.nombre AS telefonia_nombre, tel.comision AS telefonia_comision
      FROM recarga r
      JOIN telefono t ON r.telefono_id = t.id
      JOIN cliente c ON r.cliente_id = c.id
      JOIN telefonia tel ON t.telefonia_id = tel.id
      WHERE r.estado = 'Pendiente' AND r.cliente_id = ?
    ''', [clienteId]);

    // Imprime los resultados de la consulta para depuración
    // print("retrieveRecargasPendientesByCliente result: $queryResult");
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

  Future<List<Map<String, dynamic>>> obtenerRecargasPorFecha(String fecha) async {
  final Database db = await initializeDB();

  // Consulta SQL para obtener las recargas de una fecha específica
  final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT 
      recarga.id AS recarga_id,
      recarga.monto AS recarga_monto,
      recarga.fecha AS recarga_fecha,
      recarga.estado AS recarga_estado,
      telefono.numero AS telefono_numero,
      cliente.nombre AS cliente_nombre
    FROM recarga
    INNER JOIN telefono ON recarga.telefono_id = telefono.id
    INNER JOIN cliente ON telefono.cliente_id = cliente.id
    WHERE recarga.fecha = ?
    ORDER BY recarga.id
  ''', [fecha]);

  return result;
}

}
