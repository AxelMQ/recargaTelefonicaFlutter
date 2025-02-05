import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarCliente extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const AppBarCliente({Key? key, this.text})
      : preferredSize = const Size.fromHeight(67.0),
        super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 21, 93, 151),
            Color.fromARGB(255, 15, 131, 189)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: AppBar(
        title: Text(
          text ?? 'Cliente',
          style: GoogleFonts.dosis(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.arrow_back_sharp,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context); // Volver a la pantalla anterior
        //   },
        // ),
      ),
    );
  }
}
