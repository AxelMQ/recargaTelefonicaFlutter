import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/widget/HomeScreen/search_telefono_widget.dart';
import '../../screen/Cliente/cliente_screen.dart';
import '../../screen/Telefonia/telefonia_screen.dart';
import '../components/card_button.dart';

class BodyWidget extends StatelessWidget {
  const BodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SearchTelefonoWidget(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CardButton(
                text: 'Telefonia',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TelefoniaScreen()));
                },
              ),
              CardButton(
                text: 'Cliente',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ClienteScreen()));
                },
              ),
              CardButton(
                text: 'Recarga',
                onTap: () {
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
    );
  }
}
