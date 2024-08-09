import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarCobro extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const AppBarCobro({Key? key, this.text})
      : preferredSize = const Size.fromHeight(60.0),
        super(key: key);

  final String? text;

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
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: AppBar(
        title: Text(
          text ?? 'Cobro',
          style: GoogleFonts.dosis(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white70),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
    );
  }
}
