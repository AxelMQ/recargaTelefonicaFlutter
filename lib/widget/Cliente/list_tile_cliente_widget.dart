import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/cliente.dart';
import '../../screen/ClienteDetail/cliente_detail_screen.dart';

class ListTileClienteWidget extends StatelessWidget {
  const ListTileClienteWidget({
    super.key,
    required this.cliente,
    required this.deudaColor,
  });

  final Cliente cliente;
  final Color deudaColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.person,
        size: 45,
        color: Color.fromARGB(255, 80, 98, 107),
      ),
      title: Text(
        cliente.nombre,
        style: GoogleFonts.dosis(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'Deuda (bs): ${cliente.deuda}',
        style: GoogleFonts.titilliumWeb(
          fontSize: 15,
          color: deudaColor,
        ),
      ),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClienteDetailScreen(
              cliente: cliente,
            ),
          ),
        );
      },
    );
  }
}
