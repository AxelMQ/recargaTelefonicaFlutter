import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/widget/DetalleDeuda/BodyDetalleFechaDeuda.dart';
import 'package:sqflite/sqflite.dart';
import '../../widget/Cliente/app_bar_cliente.dart';

class DetalleDeudaFechaScreen extends StatelessWidget {
  final Map<String, dynamic> recarga;
  final Database database;

  // Crear una GlobalKey para acceder al estado de BodyDetalleDeudaWidget
  final GlobalKey<BodyDetalleDeudaFechaWidgetState> bodyWidgetKey =
      GlobalKey<BodyDetalleDeudaFechaWidgetState>();

  DetalleDeudaFechaScreen({
    Key? key,
    required this.recarga,
    required this.database,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Evitar que el usuario salga directamente
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return; // Si ya se está cerrando, no hacer nada

        // Aquí manejamos la lógica de confirmación antes de salir
        if (bodyWidgetKey.currentState != null) {
          await bodyWidgetKey.currentState!.confirmarSalida(context);
        }
      },
      child: Scaffold(
          appBar: const AppBarCliente(
            text: 'Detalle Deudas',
          ),
          body: BodyDetalleDeudaFechaWidget(
            key: bodyWidgetKey,
            recarga: recarga,
            database: database,
          )),
    );
  }
}
