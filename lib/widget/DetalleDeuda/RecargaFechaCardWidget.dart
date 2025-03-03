import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecargaFechaCardWidget extends StatelessWidget {
  final Map<String, dynamic> recarga;

  const RecargaFechaCardWidget({
    super.key,
    required this.recarga,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '[${recarga['telefonia_nombre']}]  ${recarga['numero_telefono']}',
                  style: GoogleFonts.dosis(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  'Monto: ${recarga['monto'].toStringAsFixed(2)} bs.',
                  style: GoogleFonts.dosis(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Text(
                  '${recarga['cliente_nombre']}',
                  style: GoogleFonts.dosis(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                Text(
                  '${recarga['estado']}',
                  style: GoogleFonts.dosis(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}