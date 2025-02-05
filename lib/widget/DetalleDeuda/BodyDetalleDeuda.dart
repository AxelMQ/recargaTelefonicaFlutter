import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/widget/DetalleDeuda/ClienteInfoWidget.dart';
import 'package:recarga_telefonica_flutter/widget/DetalleDeuda/RecargasListWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';

class BodyDetalleDeudaWidget extends StatefulWidget {
  const BodyDetalleDeudaWidget({
    super.key,
    required this.cliente,
    required this.recargas,
    required this.database,
  });

  final Map<String, dynamic> cliente;
  final List recargas;
  final Database database;

  @override
  BodyDetalleDeudaWidgetState createState() => BodyDetalleDeudaWidgetState();
}

class BodyDetalleDeudaWidgetState extends State<BodyDetalleDeudaWidget> {
  late Map<String, dynamic> cliente;
  late List recargas;
  late List recargasOriginales; // Copia de las recargas originales
  final List<Map<String, dynamic>> recargasPagadas = [];

  @override
  void initState() {
    super.initState();
    cliente = widget.cliente;
    recargas = widget.recargas;
    recargasOriginales = widget.recargas;
  }

  void marcarPagado(int index, double monto) {
    if (index < 0 || index >= recargas.length) {
      return;
    }
    setState(() {
      // Guardar la recarga en la lista temporal
      recargasPagadas.add(recargas[index]);

      // Eliminar la recarga de la lista
      recargas.removeAt(index);

      // Descontar el monto de la deuda total
      cliente['deuda_total'] -= monto;
    });
  }

  Future<void> confirmarSalida(BuildContext context) async {
    if (recargasPagadas.isEmpty) {
      // Si no hay cambios, simplemente salir
      Navigator.of(context).pop();
      return;
    }
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Guardar cambios',
            style: GoogleFonts.dosis(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            '¿Deseas guardar los cambios antes de salir?',
            style: GoogleFonts.dosis(fontSize: 17),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancelar',
                style: GoogleFonts.dosis(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                    fontSize: 17),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Guardar',
                style: GoogleFonts.dosis(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                    fontSize: 17),
              ),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      // Guardar los cambios en la base de datos
      await _guardarCambios();
    } else {
      // Restaurar las recargas originales si el usuario cancela
      setState(() {
        recargas = List.from(recargasOriginales); // Restaurar la lista original
        cliente['deuda_total'] = recargasOriginales.fold(
            0.0,
            (sum, recarga) =>
                sum +
                (recarga['recarga_monto'] ?? 0.0)); // Restaurar la deuda total
        recargasPagadas.clear(); // Limpiar la lista de recargas pagadas
      });
    }

    // Salir de la pantalla
    Navigator.of(context).pop();
  }

  Future<void> _guardarCambios() async {
    final batch = widget.database.batch();
    for (final recarga in recargasPagadas) {
      print('Recarga pagada: ${recarga['recarga_id']}');
      // Actualizar el estado de la recarga a "pagado"
      batch.update(
        'recarga',
        {'estado': 'Pagado'}, // Actualizar el estado a "Pagado"
        where: 'id = ?',
        whereArgs: [recarga['recarga_id']],
      );

      // Descontar el monto de la recarga de la deuda total del cliente
      batch.update(
        'cliente',
        {'deuda': cliente['deuda_total']},
        where: 'id = ?',
        whereArgs: [cliente['cliente_id']],
      );
    }
    await batch.commit(noResult: true);
    // Limpiar la lista temporal después de guardar los cambios
    setState(() {
      recargasPagadas.clear();
    });

    // Notificar al usuario
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recargas pagadas correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informacion del Cliente
          ClienteInfoWidget(cliente: cliente),
          // Lista de recargas detalladas
          if (recargas.isEmpty)
            Center(
              child: Text(
                'No hay recargas pendientes',
                style: GoogleFonts.dosis(
                  fontSize: 18,
                ),
              ),
            )
          else
            Recargaslistwidget(
              recargas: recargas,
              onPay: marcarPagado,
            ),
        ],
      ),
    );
  }
}
