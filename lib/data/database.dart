import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initializeDB() async {
  String path = await getDatabasesPath();
  return openDatabase(
    join(path, 'recargas.db'),
    onCreate: (database, version) async {
      await database.execute(
        "CREATE TABLE telefonia(id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT NOT NULL, comision REAL NOT NULL, logo TEXT NOT NULL, saldo REAL NOT NULL, telefono INTEGER NOT NULL)",
      );

      await database.execute(
        "CREATE TABLE cliente(id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT NOT NULL)",
      );

      await database.execute(
        "CREATE TABLE telefono(id INTEGER PRIMARY KEY AUTOINCREMENT, numero INTEGER NOT NULL, telefonia_id INTEGER NOT NULL, cliente_id INTEGER NOT NULL, FOREIGN KEY(telefonia_id) REFERENCES telefonia(id), FOREIGN KEY(cliente_id) REFERENCES cliente(id))",
      );

      await database.execute(
        "CREATE TABLE recarga(id INTEGER PRIMARY KEY AUTOINCREMENT, monto REAL NOT NULL, fecha TEXT NOT NULL, estado TEXT NOT NULL, tipo_recarga TEXT, telefono_id INTEGER NOT NULL, FOREIGN KEY(telefono_id) REFERENCES telefono(id))",
      );
      await database.execute(
        "CREATE TABLE codigoUSSD(id INTEGER PRIMARY KEY AUTOINCREMENT, codigo TEXT NOT NULL, descripcion TEXT, telefonia_id INTEGER NOT NULL, FOREIGN KEY(telefonia_id) REFERENCES telefonia(id))",
      );
    },
    version: 1,
  );
}
