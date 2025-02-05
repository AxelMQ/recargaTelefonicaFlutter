import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecargaCardWidget extends StatelessWidget {
  final Map<String, dynamic> recarga;
  final String fechaFormateada;

  const RecargaCardWidget({
    super.key,
    required this.recarga,
    required this.fechaFormateada,
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
                  '[${recarga['telefonia_nombre']}]  ${recarga['telefono_numero']}',
                  style: GoogleFonts.dosis(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  'Monto: ${recarga['recarga_monto'].toStringAsFixed(2)} bs.',
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
                  fechaFormateada,
                  style: GoogleFonts.dosis(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                Text(
                  '${recarga['recarga_estado']}',
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