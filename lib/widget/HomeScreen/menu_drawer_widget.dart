import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/screen/RecargaReporte/recarga_reporte_screen.dart';

class MenuDrawerWidget extends StatelessWidget {
  const MenuDrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 26, 86, 134),
            ),
            child: Text(
              'Menú',
              style: GoogleFonts.dosis(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              // Acción cuando se selecciona el elemento
              Navigator.pop(context); // Cierra el drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              // Acción cuando se selecciona el elemento
              Navigator.pop(context); // Cierra el drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.app_registration_rounded),
            title: Text(
              'Historial Recargas',
              style: GoogleFonts.titilliumWeb(
                  fontSize: 17, fontWeight: FontWeight.w300),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecargaReporteScreen(),
                ),
              );
            },
          )
          // Añade más elementos según sea necesario
        ],
      ),
    );
  }
}
