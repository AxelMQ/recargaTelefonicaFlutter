import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/screen/Cliente/cliente_register_screen.dart';
import 'package:recarga_telefonica_flutter/widget/components/floating_button.dart';
import '../../widget/Cliente/list_cliente_widget.dart';
import '../../model/cliente.dart';
import '../../data/cliente_dao.dart';

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({super.key});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  Future<List<Cliente>>? _clientesFuture;

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  void _loadClientes() {
    setState(() {
      _clientesFuture = ClienteDao().retrieveCliente();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      body: ListClienteWidget(
        clientesFuture: _clientesFuture!,
        onUpdate: _loadClientes,
      ),
      floatingActionButton: FloatingButton(
        text: 'Agregar Cliente.',
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ClienteRegisterScreen(),
            ),
          );

          if (result == true) {
            setState(() {
              _loadClientes();
            });
          }
        },
      ),
    );
  }
}