import 'package:flutter/material.dart';

/// Design system colors extracted from the Zippy Ride HTML designs.
/// Primary: #13ec6d, Background Light: #f6f8f7, Background Dark: #102218
class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFF13EC6D);
  static const Color primaryLight = Color(0x3313EC6D); // primary/20
  static const Color primaryFaint = Color(0x0D13EC6D); // primary/5
  static const Color primaryShadow = Color(0x3313EC6D); // primary/20 for shadows

  // Background Colors
  static const Color backgroundLight = Color(0xFFF6F8F7);
  static const Color backgroundDark = Color(0xFF102218);

  // Surface Colors
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF0F172A); // slate-900

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // slate-900
  static const Color textSecondary = Color(0xFF64748B); // slate-500
  static const Color textTertiary = Color(0xFF94A3B8); // slate-400
  static const Color textOnPrimary = Color(0xFF0F172A); // slate-900 on green

  // Border Colors
  static const Color borderLight = Color(0xFFF1F5F9); // slate-100
  static const Color borderMedium = Color(0xFFE2E8F0); // slate-200
  static const Color borderDark = Color(0xFF1E293B); // slate-800

  // Status Colors
  static const Color success = Color(0xFF13EC6D);
  static const Color warning = Color(0xFFF59E0B); // amber-500
  static const Color error = Color(0xFFF43F5E); // rose-500
  static const Color info = Color(0xFF3B82F6); // blue-500

  // Neutral Shades (Slate palette)
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);
}
