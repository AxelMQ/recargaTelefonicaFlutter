import 'package:sqflite/sqflite.dart';
import 'package:recarga_telefonica_flutter/data/database.dart';

import '../model/codigoussd.dart'; // Asegúrate de importar el archivo correcto

class CodigoUSSDDao {
  Future<Database> get _db async => await initializeDB();

  // Crear un nuevo Código USSD
  Future<void> createCodigoUSSD(CodigoUSSD codigoUSSD) async {
    final db = await _db;
    await db.insert(
      'codigoUSSD',
      codigoUSSD.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los Códigos USSD
  Future<List<CodigoUSSD>> retrieveCodigoUSSD() async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query('codigoUSSD');
    return List.generate(maps.length, (i) {
      return CodigoUSSD.fromMap(maps[i]);
    });
  }

  // Obtener un Código USSD por ID
  Future<CodigoUSSD?> retrieveCodigoUSSDById(int id) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      'codigoUSSD',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return CodigoUSSD.fromMap(maps.first);
    }
    return null;
  }

  // Obtener los Códigos USSD por ID de Telefonía
  Future<List<CodigoUSSD>> retrieveCodigoUSSDByTelefoniaId(int telefoniaId) async {
    final db = await _db;
    final List<Map<String, dynamic>> maps = await db.query(
      'codigoUSSD',
      where: 'telefonia_id = ?',
      whereArgs: [telefoniaId],
    );
    return List.generate(maps.length, (i) {
      return CodigoUSSD.fromMap(maps[i]);
    });
  }

  // Actualizar un Código USSD
  Future<void> updateCodigoUSSD(CodigoUSSD codigoUSSD) async {
    final db = await _db;
    await db.update(
      'codigoUSSD',
      codigoUSSD.toMap(),
      where: 'id = ?',
      whereArgs: [codigoUSSD.id],
    );
  }

  // Eliminar un Código USSD
  Future<void> deleteCodigoUSSD(int id) async {
    final db = await _db;
    await db.delete(
      'codigoUSSD',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
