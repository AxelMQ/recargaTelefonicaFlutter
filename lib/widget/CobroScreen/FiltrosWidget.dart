import 'package:flutter/material.dart';

class FiltrosWidget extends StatelessWidget {
  final String selectedFilter;
  final void Function(String) updateFilter;

  const FiltrosWidget({Key? key, required this.selectedFilter, required this.updateFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _filterButton('Cliente', Icons.person_2_rounded, 'cliente'),
        _filterButton('Fecha', Icons.date_range, 'fecha'),
      ],
    );
  }

  Widget _filterButton(String text, IconData icon, String filterValue) {
    final isSelected = selectedFilter == filterValue;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black,
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
      onPressed: () => updateFilter(filterValue),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.black),
          const SizedBox(width: 8.0),
          Text(text),
        ],
      ),
    );
  }
}
