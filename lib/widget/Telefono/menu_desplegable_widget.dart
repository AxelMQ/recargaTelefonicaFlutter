import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/telefonia.dart';

class MenuDesplegableWidget extends StatelessWidget {
  const MenuDesplegableWidget({
    super.key,
    required Telefonia? selectedTelefonia,
    required List<Telefonia> telefonias,
    required this.onTelefoniaChanged,
  })  : _selectedTelefonia = selectedTelefonia,
        _telefonias = telefonias;

  final Telefonia? _selectedTelefonia;
  final List<Telefonia> _telefonias;
  final ValueChanged<Telefonia?> onTelefoniaChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Telefonia>(
      value: _selectedTelefonia,
      items: _telefonias.map((telefonia) {
        return DropdownMenuItem<Telefonia>(
          value: telefonia,
          child: Text(
            telefonia.nombre,
            style: GoogleFonts.titilliumWeb(
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }).toList(),
      onChanged: onTelefoniaChanged,
      decoration: InputDecoration(
        labelText: 'Seleccionar Telefonía',
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
