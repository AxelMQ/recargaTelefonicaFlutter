import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/data/cliente_dao.dart';

class DeudaTotalWidget extends StatelessWidget {
  final ClienteDao clienteDao;

  const DeudaTotalWidget({Key? key, required this.clienteDao,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<double>(
          future: clienteDao.calcularDeudaTotal(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error al cargar la deuda total');
            } else {
              return Text(
                'Deuda Total: ${snapshot.data?.toStringAsFixed(2) ?? "0.00"} bs.',
                style: GoogleFonts.dosis(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
