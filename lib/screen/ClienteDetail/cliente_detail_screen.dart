import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/data/telefono_dao.dart';
import 'package:recarga_telefonica_flutter/widget/components/floating_button.dart';
import '../../data/recarga_dao.dart';
import '../../model/cliente.dart';
import '../../model/recarga.dart';
import '../../model/telefono.dart';
import '../../widget/Cliente/app_bar_cliente.dart';
import '../../widget/ClienteDetail/header_cliente_detail.dart';
import '../../widget/ClienteDetail/list_recargas_pendientes_widget.dart';
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
  Future<List<Recarga>>? _recargasPendientesFuture;

  @override
  void initState() {
    super.initState();
    _loadTelefonos(widget.cliente.id!);
    _loadRecargasPendientes(widget.cliente.id!);
  }

  void _loadTelefonos(int clienteId) {
    setState(() {
      _telefonosFuture = TelefonoDao().retrieveTelefonosByCliente(clienteId);
    });
  }

  void _loadRecargasPendientes(int clienteId) {
    setState(() {
      _recargasPendientesFuture =
          RecargaDao().retrieveRecargasPendientesByCliente(clienteId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCliente(
        text: widget.cliente.nombre,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderClienteDetail(
              cliente: widget.cliente,
            ),
            const Divider(
              height: 30,
              indent: 15,
              endIndent: 15,
            ),
            ListTelefonoClienteWidget(
              telefonosFuture: _telefonosFuture,
              onUpdate: () => _loadTelefonos(widget.cliente.id!),
            ),
            const Divider(
              height: 30,
              indent: 15,
              endIndent: 15,
              color: Colors.black,
            ),
            ListRecargasPendientesWidget(
              recargasFuture: _recargasPendientesFuture,
              onUpdate: () => _loadRecargasPendientes(widget.cliente.id!),
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
