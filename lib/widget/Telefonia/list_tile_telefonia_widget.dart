import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/telefonia.dart';
import '../../screen/TelefoniaDetail/telefonia_detail_screen.dart';

class ListTileTelefoniaWidget extends StatelessWidget {
  const ListTileTelefoniaWidget({
    super.key,
    required this.telefonia,
  });

  final Telefonia telefonia;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.phone,
        size: 40,
        color: Colors.blueGrey,
      ),
      title: Text(
        telefonia.nombre,
        style: GoogleFonts.dosis(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        'Comision: ${telefonia.comision} %\n'
        'Teléfono: ${telefonia.telefono} \n',
        style: GoogleFonts.titilliumWeb(
            fontSize: 15, fontWeight: FontWeight.w300),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TelefoniaDetailScreen(
              telefonia: telefonia,
            ),
          ),
        );
      },
    );
  }
}
