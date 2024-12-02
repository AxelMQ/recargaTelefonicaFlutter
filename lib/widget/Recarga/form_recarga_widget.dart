// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:recarga_telefonica_flutter/screen/Recarga/recarga_exitosa_screen.dart';
import '../../data/recarga_dao.dart';
import '../../model/recarga.dart';
import '../../model/telefono.dart';
import '../components/button_icon.dart';
import '../components/confirm_alert_dialog.dart';
import '../components/text_form.dart';
import 'option_menu_desplegable.dart';

class FormRecargasWidget extends StatefulWidget {
  const FormRecargasWidget({
    super.key,
    required this.telefono,
  });

  final Telefono telefono;

  @override
  State<FormRecargasWidget> createState() => _FormRecargasWidgetState();
}

class _FormRecargasWidgetState extends State<FormRecargasWidget> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  String? _estadoSeleccionado;
  String? _tipoRecargaSeleccionado;
  TextEditingController montoController = TextEditingController();

  final List<String> _estados = ['Pendiente', 'Pagado'];
  final List<String> _tipoRecaga = ['Credito', 'Paquetes'];

  // Método para mostrar el selector de fechas
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final recarga = Recarga(
        monto: double.parse(montoController.text),
        fecha: _selectedDate,
        estado: _estadoSeleccionado!,
        tipoRecarga: _tipoRecargaSeleccionado!,
        telefonoId: widget.telefono.id!,
        clienteId: widget.telefono.clienteId,
        telefonia: widget.telefono.telefonia,
        telefono: widget.telefono
      );

      try {
        final recargaDao = RecargaDao();
        await recargaDao.insertRecarga(recarga);
        // Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecargaExitosaScreen(recarga: recarga)),
        );

        _showMessageDialog(
          context,
          'assets/confirm-animation.json',
          'Recarga registrada exitosamente',
        );
      } catch (e) {
        _showMessageDialog(
          context,
          'assets/error-animation.json',
          'No se logro registrar la recarga: ${e.toString()}',
        );
      }

      print('Recarga creada: ${recarga.toMap()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Fecha: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}', // Formato de fecha
                  style: GoogleFonts.dosis(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black38),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            OptionMenuDesplegable<String>(
              selectedOption: _estadoSeleccionado,
              options: _estados,
              onOptionChanged: (estado) {
                setState(() {
                  _estadoSeleccionado = estado;
                });
              },
              labelText: 'Estado de la Recarga',
            ),
            const SizedBox(height: 15),
            OptionMenuDesplegable<String>(
              selectedOption: _tipoRecargaSeleccionado,
              options: _tipoRecaga,
              onOptionChanged: (tipoRecarga) {
                setState(() {
                  _tipoRecargaSeleccionado = tipoRecarga;
                });
              },
              labelText: 'Tipo de Recarga',
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 110,
                  height: 55,
                  child: TextForm(
                    text: 'Monto (bs)',
                    keyword: TextInputType.number,
                    controllerForm: montoController,
                    onValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Monto es requerido';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Ingrese un monto válido';
                      }
                      return null;
                    },
                  ),
                ),
                ButtonIconWidget(
                  onTap: _submitForm,
                  text: 'Recargar',
                  icon: Icons.phone_in_talk_rounded,
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
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
