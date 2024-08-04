// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/widget/components/button_icon.dart';
import 'package:recarga_telefonica_flutter/widget/components/text_form.dart';

import '../../data/telefonia_dao.dart';
import '../../model/telefonia.dart';
import '../components/confirm_alert_dialog.dart';

class FormEditTelefonia extends StatefulWidget {
  const FormEditTelefonia({super.key, required this.telefonia});

  final Telefonia telefonia;

  @override
  State<FormEditTelefonia> createState() => _FormEditTelefoniaState();
}

class _FormEditTelefoniaState extends State<FormEditTelefonia> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController comisionController = TextEditingController();
  final TextEditingController saldoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TelefoniaDao _telefoniaDao = TelefoniaDao();

  @override
  void initState() {
    super.initState();
    nombreController.text = widget.telefonia.nombre;
    comisionController.text = widget.telefonia.comision.toString();
    saldoController.text = widget.telefonia.saldo.toString();
    telefonoController.text = widget.telefonia.telefono.toString();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size.width;
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
                'Editar Telefonia',
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
                      text: 'Telefonia',
                      controllerForm: nombreController,
                      textCapitalization: TextCapitalization.words,
                      onValidator: (p0) =>
                          p0!.isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: screen * 0.45,
                          child: TextForm(
                            text: 'Comision (%)',
                            controllerForm: comisionController,
                            keyword: TextInputType.number,
                            onValidator: (p0) =>
                                p0!.isEmpty ? 'Campo requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: screen * 0.45,
                          child: TextForm(
                            text: 'Saldo (bs.)',
                            controllerForm: saldoController,
                            keyword: TextInputType.number,
                            onValidator: (p0) =>
                                p0!.isEmpty ? 'Campo requerido' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextForm(
                      text: 'Telefono',
                      controllerForm: telefonoController,
                      keyword: TextInputType.phone,
                      onValidator: (p0) =>
                          p0!.isEmpty ? 'Campo requerido' : null,
                    ),
                    const SizedBox(height: 20),
                    ButtonIconWidget(
                      text: 'Actualizar',
                      icon: Icons.edit,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final updateTelefonia = widget.telefonia.copyWith(
                              nombre: nombreController.text,
                              comision: double.parse(comisionController.text),
                              saldo: double.parse(saldoController.text),
                              telefono: int.parse(telefonoController.text),
                            );

                            await _telefoniaDao
                                .updateTelefonia(updateTelefonia);

                            Navigator.pop(context, true);

                            _showMessageDialog(
                              context,
                              'assets/confirm-animation.json',
                              'Telefonia actualizada exitosamente.',
                            );
                          } catch (e) {
                            _showMessageDialog(
                              context,
                              'assets/error-animation.json',
                              'Error al actualizar a la Telefonia: ${e.toString()}',
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
