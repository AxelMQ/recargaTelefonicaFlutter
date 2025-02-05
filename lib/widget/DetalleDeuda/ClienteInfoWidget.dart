import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClienteInfoWidget extends StatelessWidget {
  final Map<String, dynamic> cliente;

  const ClienteInfoWidget({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    // Obtener el valor de la deuda total
    final double deudaTotal = cliente['deuda_total'] ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.person, size: 30),
            const SizedBox(width: 8),
            Text(
              '${cliente['cliente_nombre'] ?? 'Desconocido'}',
              style: GoogleFonts.dosis(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(
              Icons.attach_money,
              color: deudaTotal > 0 ? Colors.red : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Deuda Total: ${cliente['deuda_total']?.toStringAsFixed(2)} bs.',
              style: GoogleFonts.dosis(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: deudaTotal > 0 ? Colors.red : Colors.grey,
              ),
            ),
          ],
        ),
        const Divider(
          height: 20,
          thickness: 2,
          color: Colors.grey,
        ),
      ],
    );
  }
}
