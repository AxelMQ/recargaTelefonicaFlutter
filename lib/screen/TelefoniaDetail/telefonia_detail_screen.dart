import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/widget/components/button_icon.dart';
import 'package:recarga_telefonica_flutter/widget/components/floating_button.dart';
import '../../data/codigo_ussd_dao.dart';
import '../../data/telefonia_dao.dart';
import '../../model/codigoussd.dart';
import '../../model/telefonia.dart';
import '../../widget/Cliente/app_bar_cliente.dart';
import '../../widget/TelefoniaDetail/form_add_saldo.dart';
import '../../widget/TelefoniaDetail/form_ussd.dart';
import '../../widget/components/confirm_alert_dialog.dart';
import 'list_codigo_ussd_widget.dart';

class TelefoniaDetailScreen extends StatefulWidget {
  const TelefoniaDetailScreen({
    super.key,
    required this.telefonia,
  });

  final Telefonia telefonia;

  @override
  State<TelefoniaDetailScreen> createState() => _TelefoniaDetailScreenState();
}

class _TelefoniaDetailScreenState extends State<TelefoniaDetailScreen> {
  late Telefonia _telefonia;

  @override
  void initState() {
    super.initState();
    _telefonia = widget.telefonia;
    _loadCodigoUSSDs(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCliente(text: _telefonia.nombre),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Comision: ${_telefonia.comision} %\n'
              'Teléfono: ${_telefonia.telefono} \n'
              'Saldo: ${_telefonia.saldo}\n',
              style: GoogleFonts.titilliumWeb(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
            ButtonIconWidget(
              text: 'Codigo USSD',
              icon: Icons.add,
              onTap: () async {
                final result = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return FormCodigoUSSD(
                      telefonia: _telefonia,
                    );
                  },
                );
                if (result == true) {
                  setState(() {
                    _refreshData();
                  });
                }
              },
            ),
            const Divider(
              height: 35,
            ),
            ListCodigoUSSDWidget(
              codigosUSSDFuture: _fetchCodigoUSSDs(),
              onUpdate: _refreshData,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingButton(
        text: 'Agregar Saldo',
        icon: Icons.add,
        onTap: () async {
          final result = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return FormAddSaldo(
                telefonia: _telefonia,
              );
            },
          );
          if (result == true) {
            setState(() {
              _refreshData();
            });
          }
        },
      ),
    );
  }

  Future<void> _refreshData() async {
    try {
      final telefoniaDao = TelefoniaDao();
      final updatedTelefonias = await telefoniaDao.retrieveTelefonias();
      setState(() {
        _telefonia = updatedTelefonias.firstWhere((t) => t.id == _telefonia.id);
      });
    } catch (e) {
      _showMessageDialog(
        context,
        'assets/error-animation.json',
        'Error al actualizar los datos: ${e.toString()}',
      );
    }
  }

  Future<void> _loadCodigoUSSDs() async {
    try {
      // final codigoUSSDDao = CodigoUSSDDao();
      // final ussds =
          // await codigoUSSDDao.retrieveCodigoUSSDByTelefoniaId(_telefonia.id!);
      // Haz algo con los USSDs obtenidos
    } catch (e) {
      _showMessageDialog(
        context,
        'assets/error-animation.json',
        'Error al cargar los códigos USSD: ${e.toString()}',
      );
    }
  }


  Future<List<CodigoUSSD>> _fetchCodigoUSSDs() async {
    try {
      final codigoUSSDDao = CodigoUSSDDao();
      return await codigoUSSDDao.retrieveCodigoUSSDByTelefoniaId(_telefonia.id!);
    } catch (e) {
      _showMessageDialog(
        context,
        'assets/error-animation.json',
        'Error al cargar los códigos USSD: ${e.toString()}',
      );
      return [];
    }
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
