import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/widget/HomeScreen/search_telefono_widget.dart';
import 'package:recarga_telefonica_flutter/widget/HomeScreen/telefonia_saldo_widget.dart';
import '../../model/telefonia.dart';

class BodyWidget extends StatefulWidget {
  const BodyWidget({
    super.key,
    required this.telefoniasFuture,
    required this.onUpdate,
  });

  final Future<List<Telefonia>> telefoniasFuture;
  final VoidCallback onUpdate;
  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TelefoniaSaldoWidget(
            telefoniasFuture: widget.telefoniasFuture,
            onUpdate: widget.onUpdate,
          ),
          const Divider(
            height: 40,
          ),
          const Expanded(
            child: SearchTelefonoWidget(),
          ),
        ],
      ),
    );
  }
}
