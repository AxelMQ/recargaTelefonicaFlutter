import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/data/telefonia_dao.dart';
import 'package:recarga_telefonica_flutter/screen/Telefonia/telefonia_register_screen.dart';
import '../../model/telefonia.dart';
import '../../widget/Cliente/app_bar_cliente.dart';
import '../../widget/Telefonia/list_telefonia_widget.dart';
import '../../widget/components/floating_button.dart';

class TelefoniaScreen extends StatefulWidget {
  const TelefoniaScreen({super.key});

  @override
  State<TelefoniaScreen> createState() => _TelefoniaScreenState();
}

class _TelefoniaScreenState extends State<TelefoniaScreen> {
  Future<List<Telefonia>>? _telefoniasClientes;

  @override
  void initState() {
    super.initState();
    _loadTelefonias();
  }

  void _loadTelefonias() {
    setState(() {
      _telefoniasClientes = TelefoniaDao().retrieveTelefonias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCliente(
        text: 'Telefonias',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTelefoniaWidget(
          telefoniasFuture: _telefoniasClientes!,
          onUpdate: () {
            _loadTelefonias();
          },
        ),
      ),
      floatingActionButton: FloatingButton(
        text: 'Agregar Telefonia.',
        icon: Icons.add_ic_call,
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TelefoniaRegisterScreen(),
            ),
          );

          if (result == true) {
            setState(() {
              _loadTelefonias();
            });
          }
        },
      ),
    );
  }
}
