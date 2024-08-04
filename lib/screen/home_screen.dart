import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/screen/Telefonia/telefonia_screen.dart';
import '../widget/components/card_button.dart';
import '../widget/components/text_icon_form.dart';
import 'Cliente/cliente_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recargas Telefonicas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(
            //   'IG: @axel_mq',
            //   style: GoogleFonts.dosis(fontSize: 50),
            // ),
            const TextIconForm(
              text: 'Ingrese Numero',
              icon: Icons.phone_android_rounded,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CardButton(
                  text: 'Telefonia',
                  onTap: () {
                    print('TELEFONIA');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TelefoniaScreen()));
                  },
                ),
                CardButton(
                  text: 'Cliente',
                  onTap: () {
                    print("CLIENTE BUTTON");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ClienteScreen()));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
