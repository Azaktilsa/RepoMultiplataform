import 'package:flutter/material.dart';

class PageNavigation extends StatelessWidget {
  final int currentPage;
  final int itemsPerPage;
  final int totalItems;
  final VoidCallback onNextPage;
  final VoidCallback onPreviousPage;
  final Key beforeKey;
  final Key afterKey;

  const PageNavigation({
    required this.currentPage,
    required this.itemsPerPage,
    required this.totalItems,
    required this.onNextPage,
    required this.onPreviousPage,
    required this.beforeKey,
    required this.afterKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          key: beforeKey,
          onPressed: currentPage > 0 ? onPreviousPage : null,
          style: ButtonStyle(
            backgroundColor: currentPage > 0
                ? WidgetStateProperty.all<Color>(
                    const Color.fromARGB(255, 126, 53, 0))
                : null,
          ),
          child: const Text(
            "Atrás",
            style: TextStyle(color: Color(0xfff3ece7)),
          ),
        ),
        Text(
          "Pg. ${currentPage + 1}",
          style: const TextStyle(fontSize: 16),
        ),
        ElevatedButton(
          key: afterKey,
          onPressed:
              (currentPage + 1) * itemsPerPage < totalItems ? onNextPage : null,
          style: ButtonStyle(
            backgroundColor: (currentPage + 1) * itemsPerPage < totalItems
                ? WidgetStateProperty.all<Color>(
                    const Color.fromARGB(255, 126, 53, 0))
                : null,
          ),
          child: const Text(
            "Siguiente",
            style: TextStyle(color: Color(0xfff3ece7)),
          ),
        ),
      ],
    );
  }
}
