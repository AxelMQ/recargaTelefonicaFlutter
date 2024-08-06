import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionMenuDesplegable<T> extends StatelessWidget {
  const OptionMenuDesplegable({
    super.key,
    required this.selectedOption,
    required this.options,
    required this.onOptionChanged,
    required this.labelText,
  });

  final T? selectedOption;
  final List<T> options;
  final ValueChanged<T?> onOptionChanged;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: selectedOption,
      items: options.map((option) {
        return DropdownMenuItem<T>(
          value: option,
          child: Text(
            option
                .toString(), // Cambia esto si es necesario para una mejor representación
            style: GoogleFonts.titilliumWeb(
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }).toList(),
      onChanged: onOptionChanged,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.dosis(
          color: Colors.black45,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0), // Padding del campo
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0), // Radio del borde
          borderSide: const BorderSide(
            color: Colors.grey, // Color del borde
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(
                255, 16, 109, 185), // Color del borde cuando está enfocado
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.red, // Color del borde en caso de error
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors
                .red, // Color del borde en caso de error cuando está enfocado
          ),
        ),
      ),
      validator: (value) => value == null ? 'Campo requerido' : null,
    );
  }
}
