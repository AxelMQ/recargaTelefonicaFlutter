import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertDialogWidget extends StatelessWidget {
  const AlertDialogWidget({
    super.key,
    required this.title,
    required this.content,
    required this.cancel,
    required this.confirm,
  });

  final String title;
  final String content;
  final String cancel;
  final String confirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: GoogleFonts.dosis(),
      ),
      content: Text(
        content,
        style:
            GoogleFonts.titilliumWeb(fontSize: 15, fontWeight: FontWeight.w300),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            cancel,
            style: GoogleFonts.dosis(
              fontSize: 17,
              color: const Color.fromARGB(255, 24, 96, 155),
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            confirm,
            style: GoogleFonts.dosis(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 201, 70, 61),
            ),
          ),
        )
      ],
    );
  }
}
