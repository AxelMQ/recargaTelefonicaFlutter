import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/data/cliente_dao.dart';
import 'DeudaTotalWidget.dart';
import 'FiltrosWidget.dart';
import 'package:sqflite/sqflite.dart';
import 'ClientesConDeudasWidget.dart';
import 'RecargasPorFechaWidget.dart';

class BodyCobro extends StatefulWidget {
  final ClienteDao clienteDao;
  final Database database;
  final String selectedFilter;
  final void Function(String) updateFilter;

  const BodyCobro({
    Key? key,
    required this.clienteDao,
    required this.database,
    required this.selectedFilter,
    required this.updateFilter,
  }) : super(key: key);

  @override
  State<BodyCobro> createState() => _BodyCobroState();
}

class _BodyCobroState extends State<BodyCobro> {
  late String _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DeudaTotalWidget(clienteDao: widget.clienteDao),
        const Divider(endIndent: 30, indent: 30),
        FiltrosWidget(
          selectedFilter: _selectedFilter,
          updateFilter: (filter) {
            setState(() {
              _selectedFilter = filter;
            });
            widget.updateFilter(filter);
          },
        ),
        const Divider(endIndent: 30, indent: 30),
        Expanded(
          child: _selectedFilter == 'cliente'
              ? ClientesConDeudasWidget(
                  clienteDao: widget.clienteDao,
                  database: widget.database,
                )
              : RecargasPorFechaWidget(
                  clienteDao: widget.clienteDao,
                  database: widget.database,
                ),
        ),
      ],
    );
  }
}
