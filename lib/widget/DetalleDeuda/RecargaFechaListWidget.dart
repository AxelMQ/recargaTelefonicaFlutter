import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:recarga_telefonica_flutter/widget/DetalleDeuda/RecargaFechaCardWidget.dart';

class RecargaFechalistwidget extends StatefulWidget {
  final List<Map<String, dynamic>> recargas;
  final Function(int index, double monto) onPay;

  const RecargaFechalistwidget({
    super.key,
    required this.recargas,
    required this.onPay,
  });

  @override
  State<RecargaFechalistwidget> createState() => _RecargaFechalistwidgetState();
}

class _RecargaFechalistwidgetState extends State<RecargaFechalistwidget> {
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
        itemCount: widget.recargas.length,
        itemBuilder: (context, index) {
          final recarga = widget.recargas[index];

          return Dismissible(
            key: ValueKey(recarga['recarga_id']),
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
              print('--> Deslizado: Recarga ID ${recarga['recarga_id']}');

              setState(() {
                widget.recargas.removeAt(index);
                widget.onPay(index, recarga['monto']);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Recarga de ${recarga['numero_telefono']} de ${recarga['monto']} bs. marcada como <PAGADA>',
                    style: GoogleFonts.dosis(),
                  ),
                  backgroundColor: const Color.fromARGB(255, 59, 129, 61),
                ),
              );
            },
            child: RecargaFechaCardWidget(
              recarga: recarga,
            ),
          );
        },
      ),
    );
  }
}
