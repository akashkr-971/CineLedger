import 'package:flutter/material.dart';

class CineSnack {
  static void _show(
    BuildContext context, {
    required String message,
    required Color color,
    IconData? icon,
  }) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.all(16),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  // 🔴 Error
  static void error(BuildContext context, String message) {
    _show(
      context,
      message: message,
      color: const Color(0xFFB91C1C),
      icon: Icons.error_outline,
    );
  }

  // 🟡 Warning
  static void warning(BuildContext context, String message) {
    _show(
      context,
      message: message,
      color: const Color(0xFFFBBF24),
      icon: Icons.warning_amber_rounded,
    );
  }

  // 🟢 Success
  static void success(BuildContext context, String message) {
    _show(
      context,
      message: message,
      color: const Color(0xFF16A34A),
      icon: Icons.check_circle_outline,
    );
  }
}
