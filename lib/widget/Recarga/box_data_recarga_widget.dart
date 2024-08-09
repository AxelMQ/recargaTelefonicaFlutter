import 'package:flutter/material.dart';
import '../../model/telefono.dart';
import 'form_recarga_widget.dart';

class BoxDataRecargaWidget extends StatelessWidget {
  const BoxDataRecargaWidget({
    super.key,
    required this.telefono,
  });

  final Telefono telefono;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: FormRecargasWidget(
        telefono: telefono,
      ),
    );
  }
}
