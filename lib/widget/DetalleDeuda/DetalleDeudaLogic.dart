import 'package:sqflite/sqflite.dart';

class DetalleDeudaLogic {
  final Database database;
  final Map<String, dynamic> cliente;
  List recargas;
  final List<Map<String, dynamic>> recargasPagadas = [];

  DetalleDeudaLogic({
    required this.database,
    required this.cliente,
    required this.recargas,
  });

  // Método para marcar una recarga como pagada
  void marcarPagado(int index, double monto) {
    if (index < 0 || index >= recargas.length) return;

    recargasPagadas.add(recargas[index]);
    recargas.removeAt(index);
    cliente['deuda_total'] -= monto;
  }

  // Método para guardar los cambios en la base de datos
  Future<void> guardarCambios() async {
    final batch = database.batch();
    for (final recarga in recargasPagadas) {
      batch.update(
        'recarga',
        {'estado': 'Pagado'},
        where: 'id = ?',
        whereArgs: [recarga['recarga_id']],
      );

      batch.update(
        'cliente',
        {'deuda': cliente['deuda_total']},
        where: 'id = ?',
        whereArgs: [cliente['cliente_id']],
      );
    }
    await batch.commit(noResult: true);
    recargasPagadas.clear();
  }

  // Método para restaurar las recargas originales
  void restaurarRecargas(List recargasOriginales) {
    recargas = List.from(recargasOriginales);
    cliente['deuda_total'] = recargasOriginales.fold(
      0.0,
      (sum, recarga) => sum + (recarga['recarga_monto'] ?? 0.0),
    );
    recargasPagadas.clear();
  }
}