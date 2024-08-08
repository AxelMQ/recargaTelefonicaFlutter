// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/data/cliente_dao.dart';
import 'package:recarga_telefonica_flutter/model/cliente.dart';
import '../components/button_icon.dart';
import '../components/confirm_alert_dialog.dart';
import '../components/text_form.dart';

class FormRegisterCliente extends StatefulWidget {
  const FormRegisterCliente({
    super.key,
  });

  @override
  State<FormRegisterCliente> createState() => _FormRegisterClienteState();
}

class _FormRegisterClienteState extends State<FormRegisterCliente> {
  final TextEditingController nombreController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ClienteDao _clienteDao = ClienteDao();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextForm(
            text: 'Nombre',
            textCapitalization: TextCapitalization.words,
            keyword: TextInputType.name,
            controllerForm: nombreController,
            onValidator: (p0) => p0!.isEmpty ? 'Campo requerido' : null,
          ),
          const SizedBox(height: 20),
          ButtonIconWidget(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                final cliente = Cliente(nombre: nombreController.text);

                try {
                  await _clienteDao.insertCliente(cliente);
                  nombreController.clear();

                  Navigator.pop(context, true);

                  _showMessageDialog(
                    context,
                    'assets/confirm-animation.json',
                    'Cliente Guardado exitosamente.',
                  );
                } catch (e) {
                  _showMessageDialog(
                    context,
                    'assets/error-animation.json',
                    'No se logro guardar al cliente: ${e.toString()}',
                  );
                }
              }
            },
            text: 'Guardar',
            icon: Icons.save,
          ),
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
      },
    );
  }
}
