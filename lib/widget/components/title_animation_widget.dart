import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class TitleAnimationWidget extends StatelessWidget {
  const TitleAnimationWidget({
    super.key,
    required this.img,
    required this.text,
  });

  final String img;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Lottie.asset(img),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.dosis(fontSize: 30),
            overflow: TextOverflow.fade,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
