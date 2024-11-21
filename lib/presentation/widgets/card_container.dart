import 'package:flutter/material.dart';

Widget ElevatedContainer({required Widget child, EdgeInsets? padding}) => Builder(
    builder: (context) {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white, // Background color
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!isDarkMode) // Shadows only in light mode for a flatter dark mode look
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: child,
      );
    },
  );
