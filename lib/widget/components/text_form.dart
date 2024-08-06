import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextForm extends StatelessWidget {
  const TextForm({
    super.key,
    required this.text,
    this.controllerForm,
    this.keyword,
    this.onValidator,
    this.textCapitalization = TextCapitalization.none,
  });

  final String text;
  final TextEditingController? controllerForm;
  final TextInputType? keyword;
  final String? Function(String?)? onValidator;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    String displayText = text;
    return TextFormField(
      controller: controllerForm,
      keyboardType: keyword,
      textCapitalization: textCapitalization,
      validator: onValidator,
      style: GoogleFonts.dosis(
        fontWeight: FontWeight.w300,
        fontSize: 17,
      ),
      decoration: InputDecoration(
        labelText: displayText,
        labelStyle: GoogleFonts.dosis(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 55, 96, 167),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
