// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/data/telefono_dao.dart';
import 'package:recarga_telefonica_flutter/data/telefonia_dao.dart';
import 'package:recarga_telefonica_flutter/model/cliente.dart';
import 'package:recarga_telefonica_flutter/model/telefonia.dart';
import 'package:recarga_telefonica_flutter/model/telefono.dart';
import 'package:recarga_telefonica_flutter/widget/components/button_icon.dart';
import 'package:recarga_telefonica_flutter/widget/components/text_form.dart';
import '../components/confirm_alert_dialog.dart';
import 'menu_desplegable_widget.dart';

class FormEditTelefono extends StatefulWidget {
  final Telefono telefono;

  const FormEditTelefono({
    required this.telefono,
    super.key,
  });

  @override
  State<FormEditTelefono> createState() => _FormEditTelefonoState();
}

class _FormEditTelefonoState extends State<FormEditTelefono> {
  final TextEditingController numeroController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TelefonoDao _telefonoDao = TelefonoDao();
  final TelefoniaDao _telefoniaDao = TelefoniaDao();

  Telefonia? _selectedTelefonia;
  List<Telefonia> _telefonias = [];

  @override
  void initState() {
    super.initState();
    numeroController.text = widget.telefono.numero.toString();
    _loadTelefonias();
  }

  Future<void> _loadTelefonias() async {
    final telefonias = await _telefoniaDao.retrieveTelefonias();
    setState(() {
      _telefonias = telefonias;
      _selectedTelefonia = telefonias.firstWhere(
        (t) => t.id == widget.telefono.telefonia!.id,
        orElse: () => telefonias.first,
      );
    });
  }

  Future<void> _updateTelefono() async {
    if (_formKey.currentState!.validate()) {
      final updatedTelefono = Telefono(
        id: widget.telefono.id,
        numero: int.parse(numeroController.text),
        telefoniaId: (_selectedTelefonia!.id!),
        clienteId: widget.telefono.clienteId,
      );

      try {
        await _telefonoDao.updateTelefono(updatedTelefono);
        Navigator.pop(context, true);

        _showMessageDialog(
          context,
          'assets/confirm-animation.json',
          'Teléfono actualizado exitosamente',
        );
      } catch (e) {
        _showMessageDialog(
          context,
          'assets/error-animation.json',
          'No se logró actualizar el teléfono: ${e.toString()}',
        );
      }
    }
  }

  void _onTelefoniaChanged(Telefonia? telefonia) {
    setState(() {
      _selectedTelefonia = telefonia;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Editar Teléfono',
                style: GoogleFonts.dosis(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    MenuDesplegableWidget(
                      selectedTelefonia: _selectedTelefonia,
                      telefonias: _telefonias,
                      onTelefoniaChanged: _onTelefoniaChanged,
                    ),
                    const SizedBox(height: 10),
                    TextForm(
                      text: 'Número de Teléfono',
                      controllerForm: numeroController,
                      keyword: TextInputType.phone,
                      onValidator: (p0) =>
                          p0!.isEmpty ? 'Campo requerido' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              ButtonIconWidget(
                text: 'Actualizar',
                icon: Icons.edit,
                onTap: _updateTelefono,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessageDialog(BuildContext context, String lottie, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmAlertDialog(
          message: message,
          lottie: lottie,
        );
      },
    );
  }
}
