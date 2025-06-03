import 'package:flutter/material.dart';
import 'package:azaktilza/Presentation/Utils/getBackgroundColor.dart';

class HectChip extends StatelessWidget {
  final String item;
  final bool isSelected;
  final Function(bool) onSelected;
  final String typeBackground;

  const HectChip({
    required this.item,
    required this.isSelected,
    required this.onSelected,
    required this.typeBackground,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        item,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: const Color.fromARGB(255, 126, 53, 0),
      backgroundColor: getBackgroundColor(typeBackground),
      checkmarkColor: Colors.white,
      elevation: 5,
      shadowColor: Colors.black,
      selectedShadowColor: Colors.black,
    );
  }
}
