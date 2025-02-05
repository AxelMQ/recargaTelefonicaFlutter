import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'RecargaCardWidget.dart';

class Recargaslistwidget extends StatelessWidget {
  final List recargas;
  final Function(int index, double monto) onPay;

  const Recargaslistwidget({
    super.key,
    required this.recargas,
    required this.onPay,
  });

  String formatFecha(String fecha) {
    try {
      DateTime parsedDate = DateTime.parse(fecha);
      return DateFormat("dd '/' MMMM '/' yyyy", 'es').format(parsedDate);
    } catch (e) {
      return "Fecha no disponible";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: recargas.length,
        itemBuilder: (context, index) {
          final recarga = recargas[index];
          String fechaFormateada = formatFecha(recarga['recarga_fecha'] ?? '');

          return Dismissible(
            key: Key(recarga['recarga_id'].toString()),
            direction: DismissDirection.endToStart,
            background: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.green,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Pagar',
                      style: GoogleFonts.dosis(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.attach_money_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
            onDismissed: (direction) {
              print('--> Deslizado');
              onPay(index, recarga['recarga_monto']);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Recarga de ${recarga['telefono_numero']} de ${recarga['recarga_monto']} bs. marcada como <PAGADA>',
                    style: GoogleFonts.dosis(),
                  ),
                  backgroundColor: const Color.fromARGB(255, 59, 129, 61),
                ),
              );
            },
            child: RecargaCardWidget(
              recarga: recarga,
              fechaFormateada: fechaFormateada,
            ),
          );
        },
      ),
    );
  }
}
