import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../model/recarga.dart';

class ListReporteRecargaWidget extends StatelessWidget {
  const ListReporteRecargaWidget({
    super.key,
    required Future<List<Recarga>>? recargasFuture,
  }) : _recargasFuture = recargasFuture;

  final Future<List<Recarga>>? _recargasFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recarga>>(
      future: _recargasFuture,
      builder: (context, AsyncSnapshot<List<Recarga>> snapshot) {
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
              'No se encontraron recargas disponibles.',
              style: GoogleFonts.dosis(fontSize: 17),
            ),
          );
        } else {
          final recargas = snapshot.data!;
          return ListView.builder(
            itemCount: recargas.length,
            itemBuilder: (context, index) {
              final recarga = recargas[index];
              return ListTile(
                title: Text('Monto: ${recarga.monto} bs.'),
                subtitle: Text(
                  'Fecha: ${DateFormat('dd/MM/yyyy').format(recarga.fecha)}\n'
                  'Estado: ${recarga.estado}\n'
                  'Tipo de Recarga: ${recarga.tipoRecarga}\n'
                  'Teléfono: ${recarga.telefono?.numero}\n'
                  'Cliente: ${recarga.cliente?.nombre}\n'
                  'Telefonía: ${recarga.telefonia?.nombre}',
                  style: GoogleFonts.titilliumWeb(),
                ),
              );
            },
          );
        }
      },
    );
  }
}
