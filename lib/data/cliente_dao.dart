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

  Future<List<Map<String, dynamic>>> obtenerRecargasPorCliente() async {
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
      telefonia.nombre AS telefonia_nombre,
      SUM(recarga.monto) OVER (PARTITION BY cliente.id) AS deuda_total
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

    // Consulta SQL para obtener recargas con detalles y totales por fecha
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT 
      recarga.id AS recarga_id,
      DATE(recarga.fecha) AS recarga_fecha,
      recarga.monto AS recarga_monto,
      recarga.estado AS recarga_estado,
      telefono.numero AS telefono_numero,
      cliente.nombre AS cliente_nombre,
      telefonia.nombre AS telefonia_nombre,
      SUM(recarga.monto) OVER (PARTITION BY DATE(recarga.fecha)) AS monto_total_fecha
    FROM recarga
    INNER JOIN telefono ON recarga.telefono_id = telefono.id
    INNER JOIN cliente ON telefono.cliente_id = cliente.id
    INNER JOIN telefonia ON telefono.telefonia_id = telefonia.id
    ORDER BY recarga_fecha, recarga.id
  ''');

    // Agrupar las recargas por fecha
    final Map<String, Map<String, dynamic>> recargasPorFecha = {};

    for (var recarga in result) {
      final fecha = recarga['recarga_fecha'] as String;

      // Inicializar la agrupación si no existe
      recargasPorFecha[fecha] ??= {
        'fecha': fecha,
        'monto_total':
            recarga['monto_total_fecha'], // Total acumulado por fecha
        'detalles': [],
      };

      // Añadir el detalle de la recarga a la fecha correspondiente
      recargasPorFecha[fecha]!['detalles'].add({
        'recarga_id': recarga['recarga_id'],
        'monto': recarga['recarga_monto'],
        'estado': recarga['recarga_estado'],
        'numero_telefono': recarga['telefono_numero'],
        'cliente_nombre': recarga['cliente_nombre'],
        'telefonia_nombre': recarga['telefonia_nombre'],
      });
    }

    // Convertir el mapa en una lista y ordenarla por fecha de manera descendente
    final recargasList = recargasPorFecha.values.toList();
    recargasList
        .sort((a, b) => b['fecha'].compareTo(a['fecha'])); // Orden descendente

    return recargasList;
  }
}
