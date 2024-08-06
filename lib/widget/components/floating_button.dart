import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
  });

  final String text;
  final Function() onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      tooltip: text,
      backgroundColor: const Color.fromARGB(255, 52, 115, 167),
      child: Icon(
        icon ?? Icons.add,
        color: Colors.white,
      ),
    );
  }
}
