import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/data/telefono_dao.dart';
import 'package:recarga_telefonica_flutter/widget/components/floating_button.dart';
import '../../model/cliente.dart';
import '../../model/telefono.dart';
import '../../widget/ClienteDetail/list_telefono_cliente_widget.dart';
import '../../widget/Telefono/form_register_telefono.dart';

class ClienteDetailScreen extends StatefulWidget {
  const ClienteDetailScreen({
    super.key,
    required this.cliente,
  });

  final Cliente cliente;

  @override
  State<ClienteDetailScreen> createState() => _ClienteDetailScreenState();
}

class _ClienteDetailScreenState extends State<ClienteDetailScreen> {
  Future<List<Telefono>>? _telefonosFuture;

  @override
  void initState() {
    super.initState();
    _loadTelefonos(widget.cliente.id!);
  }

  void _loadTelefonos(int clienteId) {
    setState(() {
      _telefonosFuture = TelefonoDao().retrieveTelefonosByCliente(clienteId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cliente.nombre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '-> ID: ${widget.cliente.id}',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Text(
              'Cliente: ${widget.cliente.nombre}',
              style: GoogleFonts.titilliumWeb(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 15),
            const Divider(),
            ListTelefonoClienteWidget(
              telefonosFuture: _telefonosFuture,
              onUpdate: () => _loadTelefonos(widget.cliente.id!),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingButton(
        text: 'Agregar Telefono',
        icon: Icons.add_ic_call,
        onTap: () async {
          final result = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return FormRegisterTelefono(
                cliente: widget.cliente,
              );
            },
          );

          if (result == true) {
            setState(() {
              _loadTelefonos(widget.cliente.id!);
            });
          }
        },
      ),
    );
  }
}
