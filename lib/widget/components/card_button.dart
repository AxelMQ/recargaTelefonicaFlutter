import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 100,
      child: Card(
        elevation: 3,
        color: Colors.orangeAccent,
        surfaceTintColor: Colors.black12,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.dosis(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
