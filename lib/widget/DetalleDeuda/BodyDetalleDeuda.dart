import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BodyDetalleDeudaWidget extends StatelessWidget {
  const BodyDetalleDeudaWidget({
    super.key,
    required this.cliente,
    required this.recargas,
  });

  final Map<String, dynamic> cliente;
  final List recargas;

  String formatFecha(String fecha) {
    // print('Fecha original: $fecha');
    try {
      DateTime parsedDate = DateTime.parse(fecha);
      return DateFormat("dd '/' MMMM '/' yyyy", 'es').format(parsedDate);
    } catch (e) {
      // print('Error al parsear la fecha: $e');
      return "Fecha no disponible";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${cliente['cliente_nombre'] ?? 'Desconocido'}',
            style: GoogleFonts.dosis(
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Deuda Total: ${cliente['deuda_total']?.toStringAsFixed(2)} bs.',
            style: GoogleFonts.dosis(
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
          const Divider(
            height: 20,
            thickness: 1.3,
          ),
          // Lista de recargas detalladas
          Expanded(
            child: ListView.builder(
              itemCount: recargas.length,
              itemBuilder: (context, index) {
                final recarga = recargas[index];
                //Formatear Fecha
                String fechaFormateada =
                    formatFecha(recarga['recarga_fecha'] ?? '');

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 7),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
