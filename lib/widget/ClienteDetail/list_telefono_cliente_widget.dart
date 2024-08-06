import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/data/telefono_dao.dart';
import '../../model/telefono.dart';
import '../Telefono/form_edit_telefono.dart';
import '../components/alert_dialog_widget.dart';
import '../components/confirm_alert_dialog.dart';

class ListTelefonoClienteWidget extends StatelessWidget {
  const ListTelefonoClienteWidget({
    super.key,
    required Future<List<Telefono>>? telefonosFuture,
    required this.onUpdate,
  }) : _telefonosFuture = telefonosFuture;

  final Future<List<Telefono>>? _telefonosFuture;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Telefono>>(
      future: _telefonosFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Telefono>> snapshot) {
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
              'No se encontraron Telefonos registrados.',
              style: GoogleFonts.dosis(fontSize: 17),
            ),
          );
        } else {
          final telefonos = snapshot.data!;
          return Expanded(
            child: ListView.builder(
              itemCount: telefonos.length,
              itemBuilder: (context, index) {
                final telefono = telefonos[index];
                return Dismissible(
                  key: Key(telefono.id.toString()),
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
                      //eliminar telefono
                      final confirm = await _showConfirmationDialog(context);
                      if (confirm) {
                        try {
                          await TelefonoDao()
                              .deleteTelefono(telefono.id!.toInt());

                          // ignore: use_build_context_synchronously
                          _showMessageDialog(
                            context,
                            'assets/confirm-animation.json',
                            'Telefono eliminado exitosamente',
                          );
                          return true;
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          _showMessageDialog(
                            context,
                            'assets/error-animation.json',
                            'No se logro elimnar al Telefeno: ${e.toString()}',
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
                          return FormEditTelefono(
                            telefono: telefono,
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
                      telefono.numero.toString(),
                      style: GoogleFonts.dosis(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      telefono.telefonia!.nombre,
                      style: GoogleFonts.titilliumWeb(
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
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
              content: 'Estas seguro de que quieres eliminar este Telefono?',
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
