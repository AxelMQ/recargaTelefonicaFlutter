import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/data/telefonia_dao.dart';
import 'package:recarga_telefonica_flutter/widget/Telefonia/form_edit_telefonia.dart';
import '../../model/telefonia.dart';
import '../components/alert_dialog_widget.dart';
import '../components/confirm_alert_dialog.dart';

class ListTelefoniaWidget extends StatelessWidget {
  const ListTelefoniaWidget({
    super.key,
    required this.telefoniasFuture,
    required this.onUpdate,
  });

  final Future<List<Telefonia>> telefoniasFuture;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Telefonia>>(
      future: telefoniasFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Telefonia>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No se encontraron Telefonias registradas.'),
          );
        } else {
          final telefonias = snapshot.data!;
          return ListView.builder(
            itemCount: telefonias.length,
            itemBuilder: (context, index) {
              final telefonia = telefonias[index];
              return Dismissible(
                key: Key(telefonia.id.toString()),
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
                    final confirm = await _showConfirmationDialog(context);
                    if (confirm) {
                      try {
                        await TelefoniaDao()
                            .deleteTelefonia(telefonia.id!.toInt());

                        // ignore: use_build_context_synchronously
                        _showMessageDialog(
                          context,
                          'assets/confirm-animation.json',
                          'Telefonia eliminada exitosamente',
                        );
                        return true;
                      } catch (e) {
                        // ignore: use_build_context_synchronously
                        _showMessageDialog(
                          context,
                          'assets/error-animation.json',
                          'No se logro elimnar a la Telefonia: ${e.toString()}',
                        );
                        return false;
                      }
                    } else {
                      false;
                    }
                  } else if (direction == DismissDirection.endToStart) {
                    final result = await showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return FormEditTelefonia(
                          telefonia: telefonia,
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
                  title: Text(telefonia.nombre),
                  subtitle: Text(
                      'Comision: ${telefonia.comision} - Telf: ${telefonia.telefono}'),
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
