import 'package:flutter/material.dart';
import '../../widget/Telefonia/form_register_telefonia.dart';
import '../../widget/components/title_animation_widget.dart';

class TelefoniaRegisterScreen extends StatelessWidget {
  const TelefoniaRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Telefonia'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: const [
              TitleAnimationWidget(
                text: 'REGISTRAR TELEFONIA',
                img: 'assets/form-animation.json',
              ),
              FormRegisterTelefonia(),
            ],
          ),
        ),
      ),
    );
  }
}
