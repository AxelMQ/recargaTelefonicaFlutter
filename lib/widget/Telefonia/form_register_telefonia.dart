// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/model/telefonia.dart';
import '../../data/telefonia_dao.dart';
import '../components/button_icon.dart';
import '../components/confirm_alert_dialog.dart';
import '../components/text_form.dart';

class FormRegisterTelefonia extends StatefulWidget {
  const FormRegisterTelefonia({
    super.key,
  });

  @override
  State<FormRegisterTelefonia> createState() => _FormRegisterTelefoniaState();
}

class _FormRegisterTelefoniaState extends State<FormRegisterTelefonia> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController comisionController = TextEditingController();
  final TextEditingController saldoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TelefoniaDao _telefoniaDao = TelefoniaDao();

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 30),
          TextForm(
            text: 'Telefonia',
            controllerForm: nombreController,
            keyword: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            onValidator: (p0) => p0!.isEmpty ? 'Campo requerido' : null,
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
                  onValidator: (p0) => p0!.isEmpty ? 'Campo requerido' : null,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: screen * 0.45,
                child: TextForm(
                  text: 'Saldo (bs)',
                  controllerForm: saldoController,
                  keyword: TextInputType.number,
                  onValidator: (p0) => p0!.isEmpty ? 'Campo requerido' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextForm(
            text: 'Telefono',
            controllerForm: telefonoController,
            keyword: TextInputType.phone,
            onValidator: (p0) => p0!.isEmpty ? 'Campo requerido' : null,
          ),
          const SizedBox(height: 30),
          ButtonIconWidget(
            text: 'Guardar',
            icon: Icons.save,
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                final telefonia = Telefonia(
                  nombre: nombreController.text,
                  comision: double.parse(comisionController.text),
                  saldo: double.parse(saldoController.text),
                  telefono: int.parse(telefonoController.text),
                );

                try {
                  await _telefoniaDao.insertTelefonia(telefonia);

                  Navigator.pop(context, true);

                  _showMessageDialog(
                    context,
                    'assets/confirm-animation.json',
                    'Telefonia registrada exitosamente.',
                  );
                } catch (e) {
                  _showMessageDialog(
                    context,
                    'assets/error-animation.json',
                    'No se logro registrar la telefonia: ${e.toString()}',
                  );
                }
                nombreController.clear();
                comisionController.clear();
                saldoController.clear();
                telefonoController.clear();
              }
            },
          )
        ],
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
        });
  }
}
