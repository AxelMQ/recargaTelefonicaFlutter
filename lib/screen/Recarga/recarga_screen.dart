// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      appBar: AppBar(
        title: Text(
          'Recarga - ${widget.telefono.telefonia!.nombre}',
          style: GoogleFonts.dosis(fontSize: 25),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              widget.telefono.numero.toString(),
              style: GoogleFonts.titilliumWeb(
                fontSize: 40,
              ),
            ),
            const Divider(
              indent: 85,
              endIndent: 85,
            ),
            Text(
              widget.telefono.cliente!.nombre,
              style: GoogleFonts.dosis(fontSize: 20),
            ),
            const SizedBox(height: 20),
            FormRecargasWidget(
              telefono: widget.telefono,
            )
          ],
        ),
      ),
    );
  }
}
