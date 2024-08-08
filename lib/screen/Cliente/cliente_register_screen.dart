import 'package:flutter/material.dart';
import '../../widget/Cliente/app_bar_cliente.dart';
import '../../widget/Cliente/form_register_cliente.dart';
import '../../widget/components/title_animation_widget.dart';

class ClienteRegisterScreen extends StatelessWidget {
  const ClienteRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCliente(
        text: '',
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: const [
            TitleAnimationWidget(
              text: 'REGISTRAR CLIENTE',
              img: 'assets/form-animation.json',
            ),
            Divider(
              height: 55,
              indent: 15,
              endIndent: 15,
              color: Colors.black26,
            ),
            // SizedBox(height: 35),
            FormRegisterCliente(),
          ],
        ),
      ),
    );
  }
}
