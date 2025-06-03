import 'package:flutter/material.dart';

class CustomTableRow extends TableRow {
  CustomTableRow({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    String? unit,
  }) : super(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      readOnly: readOnly,
                      decoration: InputDecoration(
                        hintText: '$label...',
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 126, 53, 0),
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 126, 53, 0),
                          ),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                  if (unit != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        unit,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
}
