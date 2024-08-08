import 'package:recarga_telefonica_flutter/data/database.dart';
import 'package:sqflite/sqflite.dart';
import '../model/cliente.dart';
import '../model/telefonia.dart';
import '../model/telefono.dart';

class TelefonoDao {
  Future<int> insertTelefono(Telefono telefono) async {
    final Database db = await initializeDB();
    return await db.insert('telefono', telefono.toMap());
  }

  Future<List<Telefono>> retrieveTelefonos() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('telefono');

    // Recupera todos los telefonías
    final List<Telefonia> telefonias = await _retrieveTelefonias();
    // Recupera todos los clientes
    final List<Cliente> clientes = await _retrieveClientes();

    // Asocia la telefonía correcta a cada teléfono
    return queryResult.map((map) {
      final telefonia = telefonias.firstWhere(
        (t) => t.id == map['telefonia_id'],
        orElse: () => Telefonia(
          id: -1,
          nombre: 'Desconocida',
          comision: -1,
          saldo: -1,
          telefono: -1,
        ),
      ); // Valor predeterminado

      final cliente = clientes.firstWhere(
        (c) => c.id == map['cliente_id'],
        orElse: () => Cliente(
          id: -1,
          nombre: 'Desconocido',
        ),
      ); // Valor predeterminado

      return Telefono.fromMap(map)
        ..telefonia = telefonia
        ..cliente = cliente;
    }).toList();
  }

  Future<List<Telefono>> retrieveTelefonosByCliente(int clienteId) async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query(
      'telefono',
      where: "cliente_id = ?",
      whereArgs: [clienteId],
    );

    // Recupera todos los telefonías
    final List<Telefonia> telefonias = await _retrieveTelefonias();
    // Recupera todos los clientes
    final List<Cliente> clientes = await _retrieveClientes();

    // Asocia la telefonía correcta a cada teléfono
    return queryResult.map((map) {
      final telefonia = telefonias.firstWhere(
        (t) => t.id == map['telefonia_id'],
        orElse: () => Telefonia(
          id: -1,
          nombre: 'Desconocida',
          comision: -1,
          saldo: -1,
          telefono: -1,
        ),
      ); // Valor predeterminado

      final cliente = clientes.firstWhere(
        (c) => c.id == map['cliente_id'],
        orElse: () => Cliente(
          id: -1,
          nombre: 'Desconocido',
        ),
      ); // Valor predeterminado

      return Telefono.fromMap(map)
        ..telefonia = telefonia
        ..cliente = cliente;
    }).toList();
  }

  Future<List<Telefono>> retrieveTelefonosByTelefonia(int telefoniaId) async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query(
      'telefono',
      where: 'telefonia_id = ?',
      whereArgs: [telefoniaId],
    );

    // Recupera todos los telefonías
    final List<Telefonia> telefonias = await _retrieveTelefonias();
    // Recupera todos los clientes
    final List<Cliente> clientes = await _retrieveClientes();

    // Asocia la telefonía y el cliente correctos a cada teléfono
    return queryResult.map((map) {
      final telefonia = telefonias.firstWhere(
        (t) => t.id == map['telefonia_id'],
        orElse: () => Telefonia(
          id: -1,
          nombre: 'Desconocida',
          comision: -1,
          saldo: -1,
          telefono: -1,
        ),
      ); // Valor predeterminado

      final cliente = clientes.firstWhere(
        (c) => c.id == map['cliente_id'],
        orElse: () => Cliente(
          id: -1,
          nombre: 'Desconocido',
        ),
      ); // Valor predeterminado

      return Telefono.fromMap(map)
        ..telefonia = telefonia
        ..cliente = cliente;
    }).toList();
  }

  Future<List<Telefono>> searchTelefonos(String searchTerm) async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(
      '''
      SELECT t.id AS telefono_id, t.numero, t.telefonia_id, t.cliente_id,
       c.id AS cliente_id, c.nombre AS cliente_nombre,
       tel.id AS telefonia_id, tel.nombre, tel.comision, tel.saldo
      FROM telefono t
      JOIN cliente c ON t.cliente_id = c.id
      JOIN telefonia tel ON t.telefonia_id = tel.id
      WHERE t.numero LIKE ?
      ''',
      ['%$searchTerm%'],
    );

    // Depura los resultados
    for (var map in queryResult) {
      print(map);
    }

    // Mapea los resultados para crear objetos Telefono y asociar datos
    return queryResult.map((map) {
      final telefono = Telefono.fromMap({
        'id': map['telefono_id'] as int?,
        'numero': map['numero'] as int,
        'telefonia_id': map['telefonia_id'] as int,
        'cliente_id': map['cliente_id'] as int,
      });
      final cliente = Cliente.fromMap({
        'id': map['cliente_id'] as int?,
        'nombre': map['cliente_nombre'] as String? ?? '',
      });
      final telefonia = Telefonia.fromMap({
        'id': map['telefonia_id'] as int?,
        'nombre': map['nombre'] as String? ?? '',
        'comision': (map['comision'] as num?)?.toDouble() ?? 0.0,
        'saldo': (map['saldo'] as num?)?.toDouble() ?? 0.0,
        'telefono': map['telefono'] as int? ?? 0,
      });

      return telefono
        ..cliente = cliente
        ..telefonia = telefonia;
    }).toList();
  }

  Future<int> updateTelefono(Telefono telefono) async {
    final Database db = await initializeDB();
    return await db.update(
      'telefono',
      telefono.toMap(),
      where: "id = ?",
      whereArgs: [telefono.id],
    );
  }

  Future<void> deleteTelefono(int id) async {
    final Database db = await initializeDB();
    await db.delete(
      'telefono',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<List<Telefonia>> _retrieveTelefonias() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('telefonia');
    return queryResult.map((map) => Telefonia.fromMap(map)).toList();
  }

  Future<List<Cliente>> _retrieveClientes() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('cliente');
    return queryResult.map((map) => Cliente.fromMap(map)).toList();
  }
}
