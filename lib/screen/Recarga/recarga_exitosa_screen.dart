// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:recarga_telefonica_flutter/model/recarga.dart';
import 'package:recarga_telefonica_flutter/screen/home_screen.dart';
import 'package:recarga_telefonica_flutter/widget/Recarga/comprobante/infor_recarga_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class RecargaExitosaScreen extends StatelessWidget {
  const RecargaExitosaScreen({
    super.key,
    required this.recarga,
  });

  final Recarga recarga;

  @override
  Widget build(BuildContext context) {
    final ScreenshotController screenshotController = ScreenshotController();

    return Scaffold(
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          color: const Color.fromARGB(255, 6, 95, 168),
           alignment: Alignment.center,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/check.png',
                              width: 100,
                              height: 100,
                            ),
                            Text(
                              'Recarga exitosa!',
                              style: GoogleFonts.dosis(
                                  color: Colors.white,
                                  fontSize: 37,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Resumen de la Transaccion',
                              style: GoogleFonts.dosis(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300),
                            ),
                            Center(
                              child: InfoRecargaWidget(recarga: recarga),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  _sharedRecargaDetails(context, screenshotController);
                                },
                                icon: const Icon(Icons.share),
                                label: const Text('COMPARTIR'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  textStyle: GoogleFonts.dosis(fontSize: 16),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                icon: const Icon(Icons.home),
                                label: const Text('VOLVER A INICIO'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  textStyle: GoogleFonts.dosis(fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sharedRecargaDetails(
      BuildContext context, ScreenshotController screenshotController) async {
    try {
      final Uint8List? image = await screenshotController.capture();
      if (image != null) {
        final String imagePath = await _saveImage(image);
        final file = File(imagePath);

        if (file.existsSync()) {
          if (kDebugMode) {
            print("Archivo encontrado: $imagePath");
          }
          Share.shareFiles([imagePath], text: 'Detalles de la Recarga');
        } else {
          _showSnackBar(
              context, 'Error: El archivo no se generó correctamente.');
        }
      } else {
        _showSnackBar(context, 'Error al capturar la pantalla.');
      }
    } catch (e) {
      _showSnackBar(context, 'Ocurrió un error inesperado: $e');
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<String> _saveImage(Uint8List image) async {
    final directory = await getTemporaryDirectory();
    final imagePath =
        '${directory.path}/recarga_exitosa_${DateTime.now().millisecondsSinceEpoch}.png';
    print("Guardando archivo en: $imagePath");
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(image);
    return imagePath;
  }
}
