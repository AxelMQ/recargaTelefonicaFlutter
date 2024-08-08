// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/model/telefonia.dart';
import '../../data/codigo_ussd_dao.dart';
import '../../model/codigoussd.dart';
import '../components/button_icon.dart';
import '../components/confirm_alert_dialog.dart';
import '../components/text_form.dart';

class FormCodigoUSSD extends StatefulWidget {
  const FormCodigoUSSD({
    super.key,
    required this.telefonia,
  });

  final Telefonia telefonia;

  @override
  State<FormCodigoUSSD> createState() => _FormCodigoUSSDState();
}

class _FormCodigoUSSDState extends State<FormCodigoUSSD> {
  final TextEditingController saldoController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                'Agregar Codigo',
                style: GoogleFonts.dosis(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Divider(
                height: 30,
                indent: 20,
                endIndent: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextForm(
                      text: 'Codigo USSD',
                      controllerForm: saldoController,
                      keyword: TextInputType.phone,
                      onValidator: (p0) =>
                          p0!.isEmpty ? 'Campo requerido.' : null,
                    ),
                    const SizedBox(height: 10),
                    TextForm(
                      text: 'Descripcion',
                      controllerForm: descripcionController,
                      keyword: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      onValidator: (p0) =>
                          p0!.isEmpty ? 'Campo requerido.' : null,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ButtonIconWidget(
                text: 'Guardar',
                icon: Icons.save,
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    final codigoUSSD = CodigoUSSD(
                      codigo: saldoController.text,
                      descripcion: descripcionController.text,
                      telefoniaId: widget.telefonia.id!,
                    );

                    try {
                      final codigoUSSDDao = CodigoUSSDDao();
                      await codigoUSSDDao.createCodigoUSSD(codigoUSSD);
                      Navigator.pop(context, true);
                      _showMessageDialog(
                        context,
                        'assets/confirm-animation.json',
                        'Codigo USSD guardado exitosamente',
                      );
                    } catch (e) {
                      _showMessageDialog(
                        context,
                        'assets/error-animation.json',
                        'Error al guardar el código USSD: ${e.toString()}',
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
          message: message,
          lottie: lottie,
        );
      },
    );
  }
}
