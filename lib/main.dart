import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/screen/home_screen.dart';


void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recarga Telefonica App',
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
    );
  }
}