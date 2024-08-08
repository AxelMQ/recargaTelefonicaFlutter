import 'package:flutter/material.dart';
import '../data/telefonia_dao.dart';
import '../model/telefonia.dart';
import '../widget/HomeScreen/app_bar_widget.dart';
import '../widget/HomeScreen/body_widget.dart';
import '../widget/HomeScreen/menu_drawer_widget.dart';
import '../widget/components/floating_button.dart';
import 'Cliente/cliente_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Telefonia>>? _telefoniasClientes;

  @override
  void initState() {
    super.initState();
    _loadTelefonias();
  }

  void _loadTelefonias() {
    setState(() {
      _telefoniasClientes = TelefoniaDao().retrieveTelefonias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        onRefresh: _loadTelefonias,
      ),
      drawer: const MenuDrawerWidget(),
      body: BodyWidget(
        telefoniasFuture: _telefoniasClientes!,
        onUpdate: _loadTelefonias,
      ),
      floatingActionButton: FloatingButton(
        text: 'Agregar Cliente',
        icon: Icons.person_add_alt_1_rounded,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ClienteScreen(),
            ),
          );
        },
      ),
    );
  }
}
