import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:recarga_telefonica_flutter/data/cliente_dao.dart';

class RecargasPorFechaWidget extends StatelessWidget {
  final ClienteDao clienteDao;

  const RecargasPorFechaWidget({Key? key, required this.clienteDao})
      : super(key: key);

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
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: clienteDao.obtenerRecargasPorFecha(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar las recargas'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final recarga = snapshot.data![index];
              final List<dynamic> detalles = recarga['detalles'] ?? [];

              //Formatear Fecha
              String fechaFormateada = formatFecha(recarga['fecha'] ?? '');

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text(
                      fechaFormateada,
                      style: GoogleFonts.dosis(
                        fontSize: 17.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Monto total: bs. ${recarga['monto_total']?.toStringAsFixed(2) ?? "0.00"}',
                      style: GoogleFonts.dosis(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      Container(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: Column(
                          children: detalles.map((detalle) {
                            return ListTile(
                              leading: const Icon(Icons.attach_money,
                                  color: Color.fromARGB(255, 77, 113, 175)),
                              title: Text(
                                'Monto: bs. ${detalle['monto'].toStringAsFixed(2)}',
                                style: GoogleFonts.dosis(fontSize: 17),
                              ),
                              subtitle: Text(
                                'Cliente: ${detalle['cliente_nombre'] ?? "Desconocido"}',
                                style: GoogleFonts.dosis(),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No hay recargas registradas.'));
        }
      },
    );
  }
}
