import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/data/cliente_dao.dart';

import '../../screen/DetalleDeuda/detalle_deuda_screen.dart';

class ClientesConDeudasWidget extends StatelessWidget {
  final ClienteDao clienteDao;

  const ClientesConDeudasWidget({Key? key, required this.clienteDao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: clienteDao.obtenerRecargasPorCliente(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar las deudas'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final cliente = snapshot.data![index];
              final List<dynamic> recargas = cliente['recargas'];

              return InkWell(
                onTap: () {
                  // Aquí puedes manejar un toque largo si lo deseas
                  // print('Long press en ${cliente['cliente_nombre']}');
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetalleDeudaScreen(cliente: cliente),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text(
                        cliente['cliente_nombre'] ?? 'Desconocido',
                        style: GoogleFonts.dosis(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Deuda: ${cliente['deuda_total'].toStringAsFixed(2)} bs.',
                        style: GoogleFonts.dosis(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      children: recargas.map((recarga) {
                        return Container(
                          color: Colors.grey.shade100,
                          child: ListTile(
                            leading: const Icon(Icons.phone_android,
                                color: Color.fromARGB(255, 77, 113, 175)),
                            title: Text(
                              '${recarga['telefonia_nombre']} - ${recarga['telefono_numero']}',
                              style: GoogleFonts.dosis(fontSize: 17),
                            ),
                            subtitle: Text(
                              'Monto: ${recarga['recarga_monto'].toStringAsFixed(2)} bs.',
                              style: GoogleFonts.dosis(),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No hay deudas pendientes.'));
        }
      },
    );
  }
}
