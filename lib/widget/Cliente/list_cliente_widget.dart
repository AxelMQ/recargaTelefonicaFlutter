import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/data/cliente_dao.dart';
import '../../model/cliente.dart';
import '../../screen/ClienteDetail/cliente_detail_screen.dart';
import '../components/alert_dialog_widget.dart';
import '../components/confirm_alert_dialog.dart';
import 'form_edit_cliente.dart';

class ListClienteWidget extends StatelessWidget {
  const ListClienteWidget({
    super.key,
    required this.clientesFuture,
    required this.onUpdate,
  });

  final Future<List<Cliente>> clientesFuture;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cliente>>(
      future: clientesFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Cliente>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: GoogleFonts.dosis(fontSize: 17),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No se encontraron Clientes registrados.',
              style: GoogleFonts.dosis(fontSize: 17),
            ),
          );
        } else {
          final clientes = snapshot.data!;
          return ListView.builder(
            itemCount: clientes.length,
            itemBuilder: (context, index) {
              final cliente = clientes[index];
              final deudaColor = cliente.deuda > 0 ? const Color.fromARGB(255, 226, 41, 28) : Colors.black;
              return Dismissible(
                key: Key(cliente.id.toString()),
                background: Container(
                  color: Colors.red,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.blue,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    //eliminar cliente
                    final confirm = await _showConfirmationDialog(context);
                    if (confirm) {
                      try {
                        await ClienteDao().deleteCliente(cliente.id!.toInt());

                        // ignore: use_build_context_synchronously
                        _showMessageDialog(
                          context,
                          'assets/confirm-animation.json',
                          'Cliente eliminado exitosamente',
                        );
                        return true;
                      } catch (e) {
                        // ignore: use_build_context_synchronously
                        _showMessageDialog(
                          context,
                          'assets/error-animation.json',
                          'No se logro elimnar al cliente: ${e.toString()}',
                        );
                        return false;
                      }
                    } else {
                      false;
                    }
                  } else if (direction == DismissDirection.endToStart) {
                    //update cliente
                    final result = await showModalBottomSheet<bool>(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return FormEditCliente(
                          cliente: cliente,
                        );
                      },
                    );
                    if (result == true) {
                      onUpdate();
                    }
                  }
                  return false;
                },
                child: ListTile(
                  title: Text(
                    cliente.nombre,
                    style: GoogleFonts.dosis(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Deuda (bs): ${cliente.deuda}',
                    style: GoogleFonts.titilliumWeb(
                      fontSize: 15,
                      color: deudaColor, 
                    ),
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClienteDetailScreen(
                          cliente: cliente,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialogWidget(
              title: 'Confirmar',
              content: 'Estas seguro de que quieres eliminar este cliente?',
              cancel: 'Cancelar',
              confirm: 'Eliminar',
            );
          },
        ) ??
        false;
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
