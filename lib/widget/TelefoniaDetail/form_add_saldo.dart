// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/data/telefonia_dao.dart';
import '../../model/telefonia.dart';
import '../components/button_icon.dart';
import '../components/confirm_alert_dialog.dart';
import '../components/text_form.dart';

class FormAddSaldo extends StatefulWidget {
  const FormAddSaldo({
    super.key,
    required this.telefonia,
  });

  final Telefonia telefonia;

  @override
  State<FormAddSaldo> createState() => _FormAddSaldoState();
}

class _FormAddSaldoState extends State<FormAddSaldo> {
  final TextEditingController saldoController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _increaseSaldo(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final saldo = double.parse(saldoController.text);
      final telefoniaDao = TelefoniaDao();

      try {
        await telefoniaDao.increaseSaldo(widget.telefonia.id!, saldo);

        Navigator.pop(context, true);

        _showMessageDialog(
          context,
          'assets/confirm-animation.json',
          'Saldo aumentado exitosamente',
        );
      } catch (e) {
        _showMessageDialog(
          context,
          'assets/error-animation.json',
          'No se logro aumentar el saldo: ${e.toString()}',
        );
      }
    }
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
                'Agregar Saldo',
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
                child: TextForm(
                  text: 'Saldo',
                  controllerForm: saldoController,
                  keyword: TextInputType.number,
                  onValidator: (p0) => p0!.isEmpty ? 'Campo requerido.' : null,
                ),
              ),
              const SizedBox(height: 20),
              ButtonIconWidget(
                text: 'Aumentar Saldo',
                icon: Icons.add,
                onTap: () async {
                  await _increaseSaldo(context);
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
