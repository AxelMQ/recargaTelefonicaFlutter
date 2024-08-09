import 'package:flutter/material.dart';
import '../widget/HomeScreen/app_bar_cobro.dart';
import '../widget/HomeScreen/menu_drawer_widget.dart';

class HomeCobroScreen extends StatelessWidget {
  const HomeCobroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarCobro(),
      drawer: MenuDrawerWidget(),
      body: Center(
        child: Text('Pantalla de Cobro'),
      ),
    );
  }
}
