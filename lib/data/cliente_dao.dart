import 'package:recarga_telefonica_flutter/data/database.dart';
import 'package:recarga_telefonica_flutter/model/cliente.dart';
import 'package:sqflite/sqflite.dart';

class ClienteDao {
  Future<List<Cliente>> searchClientes(String query,
      {int limit = 8, int offset = 0}) async {
    final Database db = await initializeDB();
    final result = await db.query('cliente',
        where: 'nombre LIKE ?',
        whereArgs: ['%$query%'],
        limit: limit,
        offset: offset,
        orderBy: 'nombre ASC');
    return result.map((json) => Cliente.fromMap(json)).toList();
  }

  Future<int> insertCliente(Cliente cliente) async {
    final Database db = await initializeDB();
    return await db.insert('cliente', cliente.toMap());
  }

  Future<List<Cliente>> retrieveCliente(
      {int limit = 20, int offset = 0}) async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query(
      'cliente',
      limit: limit,
      offset: offset,
    );
    return queryResult.map((e) => Cliente.fromMap(e)).toList();
  }

  Future<int> updateCliente(Cliente cliente) async {
    final Database db = await initializeDB();
    return await db.update(
      'cliente',
      cliente.toMap(),
      where: "id = ?",
      whereArgs: [cliente.id],
    );
  }

  Future<void> deleteCliente(int id) async {
    final Database db = await initializeDB();
    await db.delete(
      'cliente',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<double> calcularDeudaTotal() async {
    final Database db = await initializeDB();
    final result =
        await db.rawQuery('SELECT SUM(deuda) AS deuda_total FROM cliente');

    // Verifica si la consulta tiene un resultado válido
    if (result.isNotEmpty && result.first['deuda_total'] != null) {
      return result.first['deuda_total'] as double;
    }

    return 0.0; // Si no hay clientes o la deuda es nula, devuelve 0
  }

  Future<List<Cliente>> obtenerClientesDeudas() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> result = await db.query(
      'cliente',
      where: 'deuda > 0', // filtrar clientes con deuda
      orderBy: 'deuda DESC', // ordena la deuda en orden desc
    );

    //Convierte el resultado en una lista de objetos cliente
    return result.map((json) => Cliente.fromMap(json)).toList();
  }

  Future<List<Map<String, dynamic>>> obtenerClientesDeudasTelefonos() async {
    final Database db = await initializeDB();

    // Consulta JOIN entre cliente y telefono para obtener el teléfono asociado a cada cliente con deuda pendiente
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT 
      cliente.id AS cliente_id, 
      cliente.nombre AS cliente_nombre, 
      cliente.deuda, 
      telefono.numero AS telefono_numero
    FROM cliente
    LEFT JOIN telefono ON cliente.id = telefono.cliente_id
    WHERE cliente.deuda > 0
    ORDER BY cliente.deuda DESC
  ''');

    return result;
  }

  Future<List<Map<String, dynamic>>>
      obtenerRecargasPendientesConTelefonos() async {
    final Database db = await initializeDB();

    // Consulta para obtener recargas pendientes con detalles
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT 
      cliente.id AS cliente_id, 
      cliente.nombre AS cliente_nombre, 
      telefono.numero AS telefono_numero,
      recarga.id AS recarga_id,
      recarga.monto AS recarga_monto,
      recarga.estado AS recarga_estado,
      telefonia.nombre AS telefonia_nombre
    FROM recarga
    INNER JOIN telefono ON recarga.telefono_id = telefono.id
    INNER JOIN cliente ON telefono.cliente_id = cliente.id
    INNER JOIN telefonia ON telefono.telefonia_id = telefonia.id
    WHERE recarga.estado = 'Pendiente'
    ORDER BY cliente.id, recarga.id
  ''');

    return result;
  }

  Future<List<Map<String, dynamic>>> obtenerRecargasPorFecha() async {
    final Database db = await initializeDB();

    // Consulta SQL para obtener todas las recargas con sus detalles
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT 
      recarga.fecha AS recarga_fecha,
      recarga.id AS recarga_id,
      recarga.monto AS recarga_monto,
      recarga.estado AS recarga_estado,
      telefono.numero AS telefono_numero,
      cliente.nombre AS cliente_nombre,
      telefonia.nombre AS telefonia_nombre
    FROM recarga
    INNER JOIN telefono ON recarga.telefono_id = telefono.id
    INNER JOIN cliente ON telefono.cliente_id = cliente.id
    INNER JOIN telefonia ON telefono.telefonia_id = telefonia.id
    ORDER BY recarga.fecha, recarga.id
  ''');

    // Agrupar las recargas por fecha (ignorando el tiempo)
    final Map<String, List<Map<String, dynamic>>> recargasPorFecha = {};

    for (var recarga in result) {
      // Formatear la fecha para ignorar la parte de tiempo
      final fechaCompleta = recarga['recarga_fecha'] as String;
      final fecha =
          fechaCompleta.split('T')[0]; // Tomar solo la parte de la fecha

      if (!recargasPorFecha.containsKey(fecha)) {
        recargasPorFecha[fecha] = [];
      }
      recargasPorFecha[fecha]!.add(recarga);
    }

    // Convertir el mapa agrupado en una lista para facilitar su manejo
    final List<Map<String, dynamic>> agrupados = [];
    recargasPorFecha.forEach((fecha, recargas) {
      agrupados.add({'fecha': fecha, 'recargas': recargas});
    });

    return agrupados;
  }
}
