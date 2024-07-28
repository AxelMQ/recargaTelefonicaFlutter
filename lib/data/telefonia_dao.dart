import 'package:recarga_telefonica_flutter/data/database.dart';
import 'package:recarga_telefonica_flutter/model/telefonia.dart';
import 'package:sqflite/sqflite.dart';

class TelefoniaDao {
  Future<int> insertTelefonia(Telefonia telefonia) async {
    final Database db = await initializeDB();
    return await db.insert('telefonia', telefonia.toMap());
  }

  Future<List<Telefonia>> retrieveTelefonias() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('telefonia');
    return queryResult.map((e) => Telefonia.fromMap(e)).toList();
  }

  Future<int> updateTelefonia(Telefonia telefonia) async {
    final Database db = await initializeDB();
    return await db.update(
      'telefonia',
      telefonia.toMap(),
      where: "id = ?",
      whereArgs: [telefonia.id],
    );
  }

  Future<void> deleteTelefonia(int id) async {
    final Database db = await initializeDB();
    await db.delete(
      'telefonia',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
