import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/telefono.dart';

class ListTileTelefonoWidget extends StatelessWidget {
  const ListTileTelefonoWidget({
    super.key,
    required this.telefono,
  });

  final Telefono telefono;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(
            color: const Color.fromARGB(255, 189, 194, 204),
          ),
          color: Colors.white,
        ),
        child: ListTile(
          leading: const Icon(
            Icons.phone_android_rounded,
            color: Colors.blueGrey,
            size: 40,
          ),
          title: Text(
            telefono.numero.toString(),
            style: GoogleFonts.dosis(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            telefono.telefonia!.nombre,
            style: GoogleFonts.titilliumWeb(
              fontSize: 15,
            ),
          ),
          onLongPress: () {
            Clipboard.setData(
              ClipboardData(text: telefono.numero.toString()),
            ).then(
              (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Numero Copiado al portapapeles.',
                      style: GoogleFonts.dosis(
                        fontSize: 15,
                      ),
                    ),
                    backgroundColor: Colors.green,
                    elevation: 1,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
