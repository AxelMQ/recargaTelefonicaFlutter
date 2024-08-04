// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/data/cliente_dao.dart';
import 'package:recarga_telefonica_flutter/model/cliente.dart';
import 'package:recarga_telefonica_flutter/widget/components/button_icon.dart';
import 'package:recarga_telefonica_flutter/widget/components/confirm_alert_dialog.dart';
import 'package:recarga_telefonica_flutter/widget/components/text_form.dart';

class FormEditCliente extends StatefulWidget {
  final Cliente cliente;

  const FormEditCliente({
    required this.cliente,
    super.key,
  });

  @override
  _FormEditClienteState createState() => _FormEditClienteState();
}

class _FormEditClienteState extends State<FormEditCliente> {
  final TextEditingController nombreController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ClienteDao _clienteDao = ClienteDao();

  @override
  void initState() {
    super.initState();
    nombreController.text = widget.cliente.nombre;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Editar Cliente',
                style: GoogleFonts.dosis(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: TextForm(
                  controllerForm: nombreController,
                  text: 'Cliente:',
                  textCapitalization: TextCapitalization.words,
                  onValidator: (value) =>
                      value!.isEmpty ? 'Campo requerido' : null,
                ),
              ),
              const SizedBox(height: 16),
              ButtonIconWidget(
                text: 'Actualizar',
                icon: Icons.edit,
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final updatedCliente = widget.cliente.copyWith(
                        nombre: nombreController.text,
                      );
                      await _clienteDao.updateCliente(updatedCliente);

                      Navigator.pop(context, true);

                      _showMessageDialog(
                        context,
                        'assets/confirm-animation.json',
                        'Cliente actualizado exitosamente.',
                      );
                    } catch (e) {
                      _showMessageDialog(
                        context,
                        'assets/error-animation.json',
                        'Error al actualizar el cliente: ${e.toString()}',
                      );
                    }
                  }
                },
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
          lottie: lottie,
          message: message,
        );
      },
    );
  }
}
