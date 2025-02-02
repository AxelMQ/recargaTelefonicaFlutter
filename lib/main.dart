import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:recarga_telefonica_flutter/screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa los datos de fecha en español
  await initializeDateFormatting('es', null);

  // Descomenta si necesitas eliminar la base de datos
  // await deleteMyDatabase();
  //  await deleteMyDatabase();

  runApp(const MyApp());
}

// void main(){
//   runApp(const MyApp());
// }

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
