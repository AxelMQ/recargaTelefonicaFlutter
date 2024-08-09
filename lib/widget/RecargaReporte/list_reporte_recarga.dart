import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../model/recarga.dart';

class ListReporteRecargaWidget extends StatelessWidget {
  const ListReporteRecargaWidget({
    super.key,
    required List<Recarga> recargas,
    required this.onLoadMore,
    this.isLoadingMore = false,
  }) : _recargas = recargas;

  final List<Recarga> _recargas;
  final VoidCallback onLoadMore;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (!scrollInfo.metrics.outOfRange &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: _recargas.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _recargas.length) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final recarga = _recargas[index];
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
      ),
    );
  }
}
