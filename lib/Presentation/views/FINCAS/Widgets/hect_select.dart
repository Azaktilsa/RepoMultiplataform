import 'package:flutter/material.dart';
import 'package:azaktilza/Presentation/views/FINCAS/Widgets/HectChip.dart';
import 'package:azaktilza/Presentation/views/FINCAS/Widgets/PageNavigation.dart';

class HectSelectWidget extends StatelessWidget {
  final List<String> items;
  final int currentPage;
  final int itemsPerPage;
  final String title;
  final String selectedHectarea;
  final String selectedPiscina;
  final VoidCallback onNextPage;
  final VoidCallback onPreviousPage;
  final Function(String, String, bool) onSelect;
  final Key beforeKey;
  final Key afterKey;
  final Key labelKey;
  final String typeBackground;

  const HectSelectWidget({
    super.key,
    required this.items,
    required this.currentPage,
    required this.itemsPerPage,
    required this.title,
    required this.selectedHectarea,
    required this.selectedPiscina,
    required this.onNextPage,
    required this.onPreviousPage,
    required this.onSelect,
    required this.beforeKey,
    required this.afterKey,
    required this.labelKey,
    required this.typeBackground,
  });

  @override
  Widget build(BuildContext context) {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (currentPage + 1) * itemsPerPage;
    final pagedItems = items.sublist(
      startIndex,
      endIndex > items.length ? items.length : endIndex,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key: labelKey,
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Wrap(
          spacing: 10.0,
          children: pagedItems.map((item) {
            final hect = item.split(" - ")[0].replaceAll("Hect: ", "").trim();
            final pisc = item.split(" - ")[1].replaceAll("Pisc: ", "").trim();
            final isSelected =
                hect == selectedHectarea && pisc == selectedPiscina;

            return HectChip(
              typeBackground: typeBackground,
              item: item,
              isSelected: isSelected,
              onSelected: (val) => onSelect("hectareas", item, val),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        PageNavigation(
          currentPage: currentPage,
          itemsPerPage: itemsPerPage,
          totalItems: items.length,
          onNextPage: onNextPage,
          onPreviousPage: onPreviousPage,
          beforeKey: beforeKey,
          afterKey: afterKey,
        ),
      ],
    );
  }
}
