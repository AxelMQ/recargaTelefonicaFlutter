import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/widget/DetalleDeuda/DetalleFechaDeudaLogic.dart';
import 'package:recarga_telefonica_flutter/widget/DetalleDeuda/FechaInfoWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/widget/DetalleDeuda/RecargaFechaListWidget.dart';
import 'package:sqflite/sqflite.dart';

class BodyDetalleDeudaFechaWidget extends StatefulWidget {
  const BodyDetalleDeudaFechaWidget({
    super.key,
    required this.recarga,
    required this.database,
  });

  final Map<String, dynamic> recarga;
  final Database database;

  @override
  BodyDetalleDeudaFechaWidgetState createState() =>
      BodyDetalleDeudaFechaWidgetState();
}

class BodyDetalleDeudaFechaWidgetState
    extends State<BodyDetalleDeudaFechaWidget> {
  late DetalleFechaDeudaLogic logic;

  @override
  void initState() {
    super.initState();
    logic = DetalleFechaDeudaLogic(
      database: widget.database,
      fechaRecargas: widget.recarga,
      recargas: List<Map<String, dynamic>>.from(widget.recarga['detalles']),
    );
  }
  

  Future<void> confirmarSalida(BuildContext context) async {
    if (logic.recargasPagadas.isEmpty) {
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
      await logic.guardarCambios();
    } else {
      setState(() {
        logic.restaurarRecargas(
            List<Map<String, dynamic>>.from(widget.recarga['detalles']));
      });
    }

    // Salir de la pantalla
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informacion
          FechaInfoWidget(recarga: widget.recarga),
          // Lista de recargas detalladas
          if (widget.recarga.isEmpty)
            Center(
              child: Text(
                'No hay recargas pendientes',
                style: GoogleFonts.dosis(
                  fontSize: 18,
                ),
              ),
            )
          else
            RecargaFechalistwidget(
              recargas: (widget.recarga['detalles'] as List)
                  .map((e) => e as Map<String, dynamic>)
                  .toList(),
              onPay: (int index, double monto) {
                print(
                    'Pago confirmado para la recarga en el índice $index con monto $monto');
                setState(() {
                  logic.marcarPagado(index, monto);
                  widget.recarga['detalles'].removeAt(index);
                });
                // Aquí puedes agregar la lógica para marcar la recarga como pagada
              },
            )
        ],
      ),
    );
  }
}
