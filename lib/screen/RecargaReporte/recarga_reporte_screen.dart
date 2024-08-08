import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/recarga_dao.dart';
import '../../model/recarga.dart';
import '../../widget/Cliente/app_bar_cliente.dart';

class RecargaReporteScreen extends StatefulWidget {
  const RecargaReporteScreen({super.key});

  @override
  State<RecargaReporteScreen> createState() => _RecargaReporteScreenState();
}

class _RecargaReporteScreenState extends State<RecargaReporteScreen> {
  Future<List<Recarga>>? _recargasFuture;

  @override
  void initState() {
    super.initState();
    _loadRecargas();
  }

  void _loadRecargas() {
    setState(() {
      _recargasFuture = RecargaDao().retrieveRecargas();
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(_recargasFuture);
    return Scaffold(
      appBar: const AppBarCliente(
        text: 'Reporte Recargas',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Recarga>>(
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
        ),
      ),
    );
  }
}
