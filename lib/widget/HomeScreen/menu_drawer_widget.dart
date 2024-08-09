import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/screen/RecargaReporte/recarga_reporte_screen.dart';
import '../../screen/Cliente/cliente_screen.dart';
import '../../screen/Telefonia/telefonia_screen.dart';

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
          ListTileButon(
            icon: Icons.home,
            text: 'Inicio',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTileButon(
            text: 'Telefonias',
            icon: Icons.add_ic_call,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TelefoniaScreen(),
                ),
              );
            },
          ),
          ListTileButon(
            text: 'Clientes',
            icon: Icons.person_add_alt_1_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClienteScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTileButon(
            text: 'Historial Recargas',
            icon: Icons.app_registration_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecargaReporteScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ListTileButon extends StatelessWidget {
  const ListTileButon({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final String text;
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color.fromARGB(255, 32, 97, 151),
        size: 30.0,
      ),
      title: Text(
        text,
        style: GoogleFonts.titilliumWeb(
          fontSize: 17,
          fontWeight: FontWeight.w300,
          color: Colors.black,
          letterSpacing: 0.5,
        ),
      ),
      onTap: onTap,
    );
  }
}
