import 'package:sqflite/sqflite.dart';

class DetalleFechaDeudaLogic {
  final Database database;
  final Map<String, dynamic> fechaRecargas;
  List recargas;
  final List<Map<String, dynamic>> recargasPagadas = [];

  DetalleFechaDeudaLogic({
    required this.database,
    required this.fechaRecargas,
    required this.recargas,
  });

  // Método para marcar una recarga como pagada
  void marcarPagado(int index, double monto) {
    if (index < 0 || index >= recargas.length) return;

    recargasPagadas.add(recargas[index]);
    recargas.removeAt(index);
    fechaRecargas['monto_total'] -= monto;

    // Actualizar la deuda del cliente también
    if (fechaRecargas['cliente_id'] != null) {
      fechaRecargas['deuda_total'] -= monto;
      print("Nueva deuda del cliente: ${fechaRecargas['deuda_total']}");
    }
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
    }
    // Agrupar recargas por cliente y calcular la deuda total que se debe descontar
    Map<int, double> deudasPorCliente = {};

    for (final recarga in recargasPagadas) {
      int clienteId = recarga['cliente_id'];
      double monto = recarga['monto'] ?? 0.0;

      if (!deudasPorCliente.containsKey(clienteId)) {
        deudasPorCliente[clienteId] = 0.0;
      }
      deudasPorCliente[clienteId] =
          (deudasPorCliente[clienteId]! - monto).clamp(0.0, double.infinity);
    }

    // Actualizar la deuda de cada cliente
    deudasPorCliente.forEach((clienteId, deuda) {
      print("Actualizando deuda del cliente $clienteId a $deuda");
      batch.update(
        'cliente',
        {'deuda': deuda},
        where: 'id = ?',
        whereArgs: [clienteId],
      );
    });

    await batch.commit(noResult: true);
    recargasPagadas.clear();
  }

  // Método para restaurar las recargas originales
  void restaurarRecargas(List recargasOriginales) {
    recargas = List.from(recargasOriginales);
    fechaRecargas['monto_total'] = recargasOriginales.fold(
      0.0,
      (sum, recarga) => sum + (recarga['recarga_monto'] ?? 0.0),
    );

    // Restaurar la deuda del cliente también
    fechaRecargas['deuda_total'] = fechaRecargas['monto_total'];

    recargasPagadas.clear();
  }
}
