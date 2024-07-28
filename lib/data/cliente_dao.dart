import 'package:recarga_telefonica_flutter/data/database.dart';
import 'package:recarga_telefonica_flutter/model/cliente.dart';
import 'package:sqflite/sqflite.dart';

class ClienteDao {
  Future<int> insertCliente(Cliente cliente) async {
    final Database db = await initializeDB();
    return await db.insert('cliente', cliente.toMap());
  }

  Future<List<Cliente>> retrieveCliente() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('cliente');
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
}
