// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/widget/Cliente/app_bar_cliente.dart';
import '../../model/telefono.dart';
import '../../widget/Recarga/form_recarga_widget.dart';

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
              Text(
                widget.telefono.numero.toString(),
                style: GoogleFonts.titilliumWeb(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey[800],
                ),
              ),
              const Divider(
                indent: 85,
                endIndent: 85,
                thickness: 2,
                color: Colors.blueGrey,
              ),
              Text(
                widget.telefono.cliente!.nombre,
                style: GoogleFonts.dosis(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey[600],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: FormRecargasWidget(
                  telefono: widget.telefono,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
