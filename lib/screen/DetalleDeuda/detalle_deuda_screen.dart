import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/utils/screenshot_helper.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sqflite/sqflite.dart';
import '../../widget/Cliente/app_bar_cliente.dart';
import '../../widget/DetalleDeuda/BodyDetalleDeuda.dart';

class DetalleDeudaScreen extends StatelessWidget {
  final Map<String, dynamic> cliente;
  final Database database;

  // Crear una GlobalKey para acceder al estado de BodyDetalleDeudaWidget
  final GlobalKey<BodyDetalleDeudaWidgetState> bodyWidgetKey =
      GlobalKey<BodyDetalleDeudaWidgetState>();

  DetalleDeudaScreen({
    Key? key,
    required this.cliente,
    required this.database,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> recargas = cliente['recargas'] ?? [];

    // Controlador de Screenshot que se usará para capturar la pantalla
    ScreenshotController controller = ScreenshotController();

    return PopScope(
      canPop: false, // Evitar que el usuario salga directamente
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return; // Si ya se está cerrando, no hacer nada

        // Aquí manejamos la lógica de confirmación antes de salir
        if (bodyWidgetKey.currentState != null) {
          await bodyWidgetKey.currentState!.confirmarSalida(context);
        }
      },
      child: Screenshot(
        controller: controller,
        child: Scaffold(
          appBar: AppBarCliente(
            text: 'Detalle Deudas',
            action: IconButton(
              icon: const Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () async {
                await ScreenshotHelper.captureAndShare(
                  context,
                  controller,
                );
              },
            ),
          ),
          body: BodyDetalleDeudaWidget(
            key: bodyWidgetKey, // Pasar la GlobalKey al widget
            cliente: cliente,
            recargas: recargas,
            database: database,
          ),
        ),
      ),
    );
  }
}
