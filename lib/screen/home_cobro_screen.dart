import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/data/cliente_dao.dart';
import 'package:recarga_telefonica_flutter/widget/CobroScreen/BodyCobroWidget';
import '../widget/HomeScreen/app_bar_cobro.dart';
import '../widget/HomeScreen/menu_drawer_widget.dart';

class HomeCobroScreen extends StatefulWidget {
  const HomeCobroScreen({super.key});

  @override
  State<HomeCobroScreen> createState() => _HomeCobroScreenState();
}

class _HomeCobroScreenState extends State<HomeCobroScreen> {
  final clienteDao = ClienteDao();
  String _selectedFilter = 'cliente';

  void _updateFilter(String newFilter) {
    setState(() {
      _selectedFilter = newFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCobro(),
      drawer: const MenuDrawerWidget(),
      body: BodyCobro(
        clienteDao: clienteDao,
        selectedFilter: _selectedFilter,
        updateFilter: _updateFilter,
      ),
    );
  }
}
