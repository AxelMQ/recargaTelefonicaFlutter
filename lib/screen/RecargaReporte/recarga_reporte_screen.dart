import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/widget/components/button_icon.dart';
import '../../data/recarga_dao.dart';
import '../../model/recarga.dart';
import '../../widget/Cliente/app_bar_cliente.dart';
import '../../widget/RecargaReporte/list_reporte_recarga.dart';

class RecargaReporteScreen extends StatefulWidget {
  const RecargaReporteScreen({super.key});

  @override
  State<RecargaReporteScreen> createState() => _RecargaReporteScreenState();
}

class _RecargaReporteScreenState extends State<RecargaReporteScreen> {
  Future<List<Recarga>>? _recargasFuture;
  String _filter = 'todo';

  @override
  void initState() {
    super.initState();
    _loadRecargas();
  }

  void _loadRecargas({String filter = 'todo'}) {
    setState(() {
      _filter = filter;
      _recargasFuture = RecargaDao().retrieveRecargas(filter: filter);
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(_recargasFuture);
    return Scaffold(
      appBar: const AppBarCliente(
        text: 'Historial Recargas',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _filterButton('Todo', Icons.all_inclusive, 'todo'),
                _filterButton('Pendiente', Icons.pending, 'Pendiente'),
                _filterButton('Pagado', Icons.check_circle, 'Pagado'),
              ],
            ),
            const Divider(
              height: 25,
              indent: 15,
              endIndent: 15,
            ),
            Expanded(
              child: ListReporteRecargaWidget(
                recargasFuture: _recargasFuture,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterButton(String text, IconData icon, String filterValue) {
    final isSelected = _filter == filterValue;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black,
        backgroundColor:
            isSelected ? Colors.blue : Colors.grey[300], // Color del texto
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
      onPressed: () => _loadRecargas(filter: filterValue),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.black),
          const SizedBox(width: 8.0),
          Text(text),
        ],
      ),
    );
  }
}
