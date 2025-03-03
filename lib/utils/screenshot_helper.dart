import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ScreenshotHelper {
  /// Captura la pantalla y comparte la imagen
  static Future<void> captureAndShare(BuildContext context,
      ScreenshotController controller) async {
    try {
      final Uint8List? image = await controller.capture();

      if (image != null) {
        final String imagePath = await _saveImage(image);
        final file = File(imagePath);

        if (file.existsSync()) {
          if (kDebugMode) {
            print("Archivo encontrado: $imagePath");
          }
          // ignore: deprecated_member_use
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

  /// Guarda la imagen en el almacenamiento temporal
  static Future<String> _saveImage(Uint8List image) async {
    final directory = await getTemporaryDirectory();
    final imagePath =
        '${directory.path}/comprobante_deuda_${DateTime.now().millisecondsSinceEpoch}.png';
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(image);
    return imagePath;
  }

  /// Muestra un mensaje en un `SnackBar`
  static void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
