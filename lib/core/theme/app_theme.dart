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
      onSurface: Color(0xFFF1F1F1),
    ),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Color(0xFF9CA3AF))),
  );
}
