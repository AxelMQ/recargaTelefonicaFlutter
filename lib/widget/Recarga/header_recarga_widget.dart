import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/telefono.dart';

class HeaderRecargaWidget extends StatelessWidget {
  const HeaderRecargaWidget({
    super.key,
    required this.telefono,
  });

  final Telefono telefono;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          telefono.numero.toString(),
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
          telefono.cliente!.nombre,
          style: GoogleFonts.dosis(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey[600],
          ),
        ),
      ],
    );
  }
}
