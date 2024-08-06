// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/data/telefono_dao.dart';
import 'package:recarga_telefonica_flutter/widget/components/button_icon.dart';
import 'package:recarga_telefonica_flutter/widget/components/text_form.dart';
import '../../data/telefonia_dao.dart';
import '../../model/cliente.dart';
import '../../model/telefonia.dart';
import '../../model/telefono.dart';
import '../components/confirm_alert_dialog.dart';
import 'menu_desplegable_widget.dart';

class FormRegisterTelefono extends StatefulWidget {
  const FormRegisterTelefono({
    super.key,
    required this.cliente,
  });

  final Cliente cliente;

  @override
  State<FormRegisterTelefono> createState() => _FormRegisterTelefonoState();
}

class _FormRegisterTelefonoState extends State<FormRegisterTelefono> {
  final TextEditingController numeroController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TelefonoDao _telefonoDao = TelefonoDao();
  final TelefoniaDao _telefoniaDao = TelefoniaDao();

  Telefonia? _selectedTelefonia;
  List<Telefonia> _telefonias = [];

  @override
  void initState() {
    super.initState();
    _loadTelefonias();
  }

  Future<void> _loadTelefonias() async {
    final telefonias = await _telefoniaDao.retrieveTelefonias();
    setState(() {
      _telefonias = telefonias;
    });
  }

  void _saveTelefono() async {
    if (_formKey.currentState!.validate()) {
      final telefono = Telefono(
        numero: int.parse(numeroController.text),
        telefoniaId: _selectedTelefonia!.id!,
        clienteId: widget.cliente.id!,
      );

      try {
        await _telefonoDao.insertTelefono(telefono);
        Navigator.pop(context, true);

        _showMessageDialog(
          context,
          'assets/confirm-animation.json',
          'Telefono registrado exitosamente',
        );
      } catch (e) {
        _showMessageDialog(
          context,
          'assets/error-animation.json',
          'No se logro registrar el telefono: ${e.toString()}',
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
                'Agregar Telefono a ${widget.cliente.nombre}',
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
                      text: 'Telefono',
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
                text: 'Guardar',
                icon: Icons.save,
                onTap: _saveTelefono,
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
