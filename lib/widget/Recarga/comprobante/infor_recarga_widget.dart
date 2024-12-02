import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:recarga_telefonica_flutter/model/recarga.dart';

class InfoRecargaWidget extends StatelessWidget {
  const InfoRecargaWidget({
    super.key,
    required this.recarga,
  });

  final Recarga recarga;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Comprobante de Recarga',
                style: GoogleFonts.dosis(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 7),
            _buildDetailRow(
              'Número:',
              recarga.telefono?.numero.toString() ?? 'No especificado',
            ),
            _buildDetailRow(
              'Telefonía:',
              recarga.telefonia?.nombre ?? 'Sin información de telefonía',
            ),
            _buildDetailRow(
                'Fecha: ', DateFormat('dd/MM/yyyy').format(recarga.fecha)),
            _buildDetailRow('Estado:', recarga.estado),
            _buildDetailRow('Tipo de Recarga:', recarga.tipoRecarga),
            _buildDetailRow('Monto (bs) :', recarga.monto.toString()),
          ],
        ),
      ),
    );
  }
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.dosis(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Text(
          value,
          style: GoogleFonts.dosis(fontSize: 18),
        ),
      ],
    ),
  );
}
