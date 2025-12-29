import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF0B0D12),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4F46E5),
      secondary: Color(0xFFFBBF24),
      surface: Color(0xFF181A20),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Color(0xFFF1F1F1),
    ),

    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Color(0xFF9CA3AF)),
      bodySmall: TextStyle(color: Color(0xFF6B7280)),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: const Color(0xFFF9FAFB),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4F46E5),
      secondary: Color(0xFFF59E0B),
      surface: Colors.white,
      onPrimary: Color.fromARGB(192, 255, 255, 255),
      onSecondary: Colors.black,
      onSurface: Color(0xFF111827),
    ),

    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        color: Color(0xFF111827),
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF111827),
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(color: Color(0xFF374151)),
      bodySmall: TextStyle(color: Color(0xFF6B7280)),
    ),
  );
}
