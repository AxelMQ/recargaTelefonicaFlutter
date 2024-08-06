import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const AppBarWidget({Key? key})
      : preferredSize = const Size.fromHeight(60.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 26, 86, 134),
            Color.fromARGB(255, 36, 147, 202)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: AppBar(
        title: Text(
          'Recargas Telefonicas',
          style: GoogleFonts.dosis(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white70,
            ),
            onPressed: () {
              // Acción del botón de menú
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white70),
          onPressed: () {
            // Acción del botón de menú (izquierda)
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      
    );
  }
}
