// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/widget/Cliente/app_bar_cliente.dart';
import '../../model/telefono.dart';
import '../../widget/Recarga/box_data_recarga_widget.dart';
import '../../widget/Recarga/header_recarga_widget.dart';

class RecargaScreen extends StatefulWidget {
  const RecargaScreen({
    super.key,
    required this.telefono,
  });

  final Telefono telefono;

  @override
  State<RecargaScreen> createState() => _RecargaScreenState();
}

class _RecargaScreenState extends State<RecargaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCliente(
        text: 'Recarga ${widget.telefono.telefonia!.nombre}',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              HeaderRecargaWidget(
                telefono: widget.telefono,
              ),
              const SizedBox(height: 20),
              BoxDataRecargaWidget(
                telefono: widget.telefono,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
