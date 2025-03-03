import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/widget/DetalleDeuda/ClienteInfoWidget.dart';
import 'package:recarga_telefonica_flutter/widget/DetalleDeuda/DetalleDeudaLogic.dart';
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
  late DetalleDeudaLogic logic;

  @override
  void initState() {
    super.initState();
    logic = DetalleDeudaLogic(
      database: widget.database,
      cliente: widget.cliente,
      recargas: widget.recargas,
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
        logic.restaurarRecargas(widget.recargas);
      });
    }

    // Salir de la pantalla
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informacion del Cliente
          ClienteInfoWidget(cliente: widget.cliente),
          // Lista de recargas detalladas
          if (widget.recargas.isEmpty)
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
              recargas: widget.recargas,
              onPay: (recarga, monto) {
                setState(() {
                  logic.marcarPagado(recarga, monto);
                });
              },
            ),
        ],
      ),
    );
  }
}
