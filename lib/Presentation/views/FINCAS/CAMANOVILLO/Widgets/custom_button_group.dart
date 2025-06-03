// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class CustomSingleChipSelector extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final Function(String) onItemSelected;

  const CustomSingleChipSelector({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        final isSelected = selectedItem == item;
        return FilterChip(
          label: Text(
            item,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          selected: isSelected,
          onSelected: (_) => onItemSelected(item),
          shadowColor: Colors.black,
          selectedShadowColor: Colors.black,
          elevation: 5,
          selectedColor: const Color.fromARGB(255, 126, 53, 0),
          backgroundColor: const Color.fromARGB(255, 241, 238, 235),
          checkmarkColor: Colors.white,
        );
      }).toList(),
    );
  }
}
