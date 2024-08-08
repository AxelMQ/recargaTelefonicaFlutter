// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/data/codigo_ussd_dao.dart';
import '../../model/codigoussd.dart';
import '../../widget/TelefoniaDetail/form_edit_codigoussd.dart';
import '../../widget/components/alert_dialog_widget.dart';
import '../../widget/components/confirm_alert_dialog.dart';

class ListCodigoUSSDWidget extends StatelessWidget {
  const ListCodigoUSSDWidget({
    super.key,
    required Future<List<CodigoUSSD>>? codigosUSSDFuture,
    required this.onUpdate,
  }) : _codigosUSSDFuture = codigosUSSDFuture;

  final Future<List<CodigoUSSD>>? _codigosUSSDFuture;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CodigoUSSD>>(
      future: _codigosUSSDFuture,
      builder:
          (BuildContext context, AsyncSnapshot<List<CodigoUSSD>> snapshot) {
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
              'No hay códigos USSD.',
              style: GoogleFonts.dosis(fontSize: 17),
            ),
          );
        } else {
          final codigosUSSD = snapshot.data!;
          return Expanded(
            child: ListView.builder(
              itemCount: codigosUSSD.length,
              itemBuilder: (context, index) {
                final codigoUSSD = codigosUSSD[index];
                return Dismissible(
                  key: Key(codigoUSSD.id.toString()),
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
                      // Confirmar eliminación
                      final confirm = await _showConfirmationDialog(context);
                      if (confirm) {
                        if (codigoUSSD.id != null) {
                          try {
                            await CodigoUSSDDao()
                                .deleteCodigoUSSD(codigoUSSD.id!);
                            _showMessageDialog(
                              context,
                              'assets/confirm-animation.json',
                              'Codigo USSD eliminado exitosamente',
                            );
                            return true;
                          } catch (e) {
                            _showMessageDialog(
                              context,
                              'assets/error-animation.json',
                              'No se logró eliminar el Codigo USSD: ${e.toString()}',
                            );
                            return false;
                          }
                        } else {
                          _showMessageDialog(
                            context,
                            'assets/error-animation.json',
                            'ID del Codigo USSD es nulo',
                          );
                          return false;
                        }
                      } else {
                        return false;
                      }
                    } else if (direction == DismissDirection.endToStart) {
                      // Manejar la edición
                      final result = await showModalBottomSheet<bool>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return FormEditCodigoUSSD(
                            codigoUSSD: codigoUSSD,
                          );
                        },
                      );
                      if (result == true) {
                        onUpdate();
                      }
                      return false;
                    }
                    
                    return false;
                  },
                  child: ListTile(
                    title: Text(
                      codigoUSSD.codigo,
                      style: GoogleFonts.dosis(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      codigoUSSD.descripcion!,
                      style: GoogleFonts.titilliumWeb(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
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
              content: 'Estas seguro de que quieres el codigo USSD?',
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
