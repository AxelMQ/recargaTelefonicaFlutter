import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/telefono.dart';
import '../../screen/Recarga/recarga_screen.dart';

class ListTileSearchTelefonos extends StatelessWidget {
  const ListTileSearchTelefonos({
    super.key,
    required this.telefono,
    required this.subtitle,
  });

  final Telefono telefono;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(
            color: const Color.fromARGB(255, 189, 194, 204),
          ),
          color: const Color.fromRGBO(247, 245, 240, 1),
        ),
        child: ListTile(
          leading: const Icon(
            Icons.phone_android_rounded,
            color: Colors.blueGrey,
            size: 40,
          ),
          title: Text(
            telefono.numero.toString(),
            style: GoogleFonts.titilliumWeb(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.blueGrey[800],
            ),
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.dosis(
              fontWeight: FontWeight.w300,
              fontSize: 17,
              color: Colors.blueGrey[600],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecargaScreen(
                  telefono: telefono,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
