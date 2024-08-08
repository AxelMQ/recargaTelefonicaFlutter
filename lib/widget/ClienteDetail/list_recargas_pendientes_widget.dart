import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../model/recarga.dart';

class ListRecargasPendientesWidget extends StatelessWidget {
  const ListRecargasPendientesWidget({
    super.key,
    required Future<List<Recarga>>? recargasFuture,
    required this.onUpdate,
  }) : _recargasFuture = recargasFuture;

  final Future<List<Recarga>>? _recargasFuture;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recarga>>(
      future: _recargasFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Recarga>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: GoogleFonts.dosis(fontSize: 17),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No hay recargas pendientes.',
              style: GoogleFonts.dosis(fontSize: 17),
            ),
          );
        } else {
          final recargas = snapshot.data!;
          return Expanded(
            child: ListView.builder(
              itemCount: recargas.length,
              itemBuilder: (context, index) {
                final recarga = recargas[index];
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${recarga.telefonia!.nombre}: ${recarga.telefono!.numero}',
                        style: GoogleFonts.dosis(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(recarga.fecha),
                        style: GoogleFonts.dosis(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Monto: ${recarga.monto}',
                        style: GoogleFonts.titilliumWeb(
                          fontSize: 18,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                      Text(
                        recarga.estado,
                        style: GoogleFonts.titilliumWeb(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
