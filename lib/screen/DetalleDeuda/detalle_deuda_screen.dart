import 'package:flutter/material.dart';
import '../../widget/Cliente/app_bar_cliente.dart';
import '../../widget/DetalleDeuda/BodyDetalleDeuda.dart';

class DetalleDeudaScreen extends StatelessWidget {
  final Map<String, dynamic> cliente;

  const DetalleDeudaScreen({Key? key, required this.cliente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> recargas = cliente['recargas'] ?? [];

    return Scaffold(
      appBar: const AppBarCliente(
        text: 'Detalle Deudas',
      ),
      body: BodyDetalleDeudaWidget(cliente: cliente, recargas: recargas),
    );
  }
}
