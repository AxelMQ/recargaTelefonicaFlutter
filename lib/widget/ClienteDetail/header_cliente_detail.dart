import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/cliente.dart';

class HeaderClienteDetail extends StatelessWidget {
  const HeaderClienteDetail({
    super.key,
    required this.cliente,
  });

  final Cliente cliente;

  @override
  Widget build(BuildContext context) {
    final deudaColor = cliente.deuda > 0
        ? const Color.fromARGB(255, 226, 41, 28)
        : Colors.black;
    return Column(
      children: [
        Text(
          'Deuda (bs):  ${cliente.deuda}',
          style: GoogleFonts.titilliumWeb(
            fontSize: 23,
            fontWeight: FontWeight.w600,
            color: deudaColor,
          ),
        ),
      ],
    );
  }
}
