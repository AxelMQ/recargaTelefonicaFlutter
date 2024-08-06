import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/HomeScreen/app_bar_widget.dart';
import '../widget/HomeScreen/body_widget.dart';
import '../widget/HomeScreen/menu_drawer_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      drawer: MenuDrawerWidget(),
      body: BodyWidget(),
    );
  }
}
