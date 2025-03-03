import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FechaInfoWidget extends StatelessWidget {
  final Map<String, dynamic> recarga;

  const FechaInfoWidget({
    super.key,
    required this.recarga,
  });

  String formatFecha(String fecha) {
    try {
      DateTime parsedDate = DateTime.parse(fecha);
      return DateFormat("dd 'de' MMMM 'del' yyyy", 'es').format(parsedDate);
    } catch (e) {
      return "Fecha no disponible";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verificar si hay datos
    if (recarga.isEmpty) {
      return const Center(child: Text("No hay recargas disponibles"));
    }

    // Acceder correctamente a la fecha y monto total
    String fechaFormateada = formatFecha(recarga['fecha'] ?? '');
    double deudaTotal = (recarga['monto_total'] is num) ? recarga['monto_total'].toDouble() : 0.0;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_month, size: 30),
            const SizedBox(width: 8),
            Text(
              fechaFormateada,
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
              'Deuda Total: ${recarga['monto_total']?.toStringAsFixed(2)} bs.',
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
