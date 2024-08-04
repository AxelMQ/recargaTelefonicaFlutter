import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ConfirmAlertDialog extends StatelessWidget {
  const ConfirmAlertDialog({
    super.key,
    required this.lottie,
    required this.message,
  });

  final String lottie;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(lottie),
          const SizedBox(height: 20),
          Text(
            message,
            style: GoogleFonts.titilliumWeb(
              fontSize: 17,
              fontWeight: FontWeight.w300,
            ),
          )
        ],
      ),
    );
  }
}
