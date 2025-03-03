import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/data/cliente_dao.dart';
import 'package:recarga_telefonica_flutter/widget/CobroScreen/BodyCobroWidget.dart';
import '../widget/HomeScreen/app_bar_cobro.dart';
import '../widget/HomeScreen/menu_drawer_widget.dart';
import 'package:sqflite/sqflite.dart';
import 'package:recarga_telefonica_flutter/data/database.dart';

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
      body: FutureBuilder<Database>(
        future: initializeDB(), // Espera la inicialización de la base de datos
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar la base de datos: ${snapshot.error}',
                style: GoogleFonts.dosis(),
              ),
            );
          } else {
            // Una vez que la base de datos está lista, la pasamos al BodyCobro
            return BodyCobro(
              clienteDao: clienteDao,
              database: snapshot.data!,
              selectedFilter: _selectedFilter,
              updateFilter: _updateFilter,
            );
          }
        },
      ),
    );
  }
}
