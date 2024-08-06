import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextIconForm extends StatelessWidget {
  const TextIconForm({
    super.key,
    required this.text,
    required this.icon,
    required this.controller,
  });

  final String text;
  final IconData icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      style: GoogleFonts.dosis(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: text,
        labelStyle: GoogleFonts.dosis(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Colors.black87,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0,),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 82, 123, 196),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.black54,
        ),
      ),
    );
  }
}
