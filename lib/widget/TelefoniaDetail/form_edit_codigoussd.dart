// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/data/codigo_ussd_dao.dart';
import '../../model/codigoussd.dart';
import '../components/button_icon.dart';
import '../components/confirm_alert_dialog.dart';
import '../components/text_form.dart';

class FormEditCodigoUSSD extends StatefulWidget {
  const FormEditCodigoUSSD({super.key, required this.codigoUSSD});

  final CodigoUSSD codigoUSSD;

  @override
  State<FormEditCodigoUSSD> createState() => _FormEditCodigoUSSDState();
}

class _FormEditCodigoUSSDState extends State<FormEditCodigoUSSD> {
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CodigoUSSDDao _codigoUSSDDao = CodigoUSSDDao();

  @override
  void initState() {
    super.initState();
    codigoController.text = widget.codigoUSSD.codigo;
    descripcionController.text = widget.codigoUSSD.descripcion ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Editar Código USSD',
                style: GoogleFonts.dosis(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextForm(
                      text: 'Código',
                      controllerForm: codigoController,
                      onValidator: (p0) => p0!.isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 10),
                    TextForm(
                      text: 'Descripción',
                      controllerForm: descripcionController,
                      textCapitalization: TextCapitalization.words,
                      onValidator: (p0) => p0!.isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 20),
                    ButtonIconWidget(
                      text: 'Actualizar',
                      icon: Icons.edit,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final updatedCodigoUSSD = widget.codigoUSSD.copyWith(
                              codigo: codigoController.text,
                              descripcion: descripcionController.text,
                            );

                            await _codigoUSSDDao.updateCodigoUSSD(updatedCodigoUSSD);

                            Navigator.pop(context, true);

                            _showMessageDialog(
                              context,
                              'assets/confirm-animation.json',
                              'Código USSD actualizado exitosamente.',
                            );
                          } catch (e) {
                            _showMessageDialog(
                              context,
                              'assets/error-animation.json',
                              'Error al actualizar el Código USSD: ${e.toString()}',
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
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
