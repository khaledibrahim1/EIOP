import 'package:flutter/material.dart';
import '../models/cart_state.dart';

class AppColors {
  // Primary Orange Theme Palette
  static const Color primary = Color(0xFFFF5216); // Vibrant Primary Orange
  // Dynamic Light Orange Tint
  static Color get primaryLight => appState.isDarkMode
      ? const Color(0xFF2E201B)
      : const Color(0xFFFFF1ED);

  static const Color primaryDark = Color(0xFFD83B06); // Deep Sunset Orange
  static const Color accentYellow = Color(0xFFFFB800); // Warm Golden Amber
  static const Color accentLime = Color(0xFFFF5216); // Accent Match

  // Dynamic Surfaces & Backgrounds
  static Color get background => appState.isDarkMode
      ? const Color(0xFF12121A) // Deep Night Navy Background
      : const Color(0xFFF9FAFC); // Clean Daylight Background

  static Color get surface => appState.isDarkMode
      ? const Color(0xFF1C1C28) // Dark Navy Surface Card
      : Colors.white; // Pure White Surface

  static Color get cardBg => appState.isDarkMode
      ? const Color(0xFF252536) // Dark Fill
      : const Color(0xFFF4F5F7); // Soft Light Fill

  // Dynamic Typography Colors
  static Color get textPrimary => appState.isDarkMode
      ? const Color(0xFFF5F5FA) // Bright White Text in Dark Mode
      : const Color(0xFF1E1E2D); // Deep Charcoal Text in Light Mode

  static Color get textSecondary => appState.isDarkMode
      ? const Color(0xFFA0A0B4) // Soft Muted Light Text
      : const Color(0xFF8A8A9E); // Soft Steel Grey Text

  static Color get textLight => appState.isDarkMode
      ? const Color(0xFF6E6E85)
      : const Color(0xFFB5B5C3);

  // Dynamic Header Gradient
  static LinearGradient get headerFadeGradient => appState.isDarkMode
      ? const LinearGradient(
          colors: [
            Color(0xFF2A1C16), // Dark warm orange top
            Color(0xFF201614), // Smooth dark transition
            Color(0xFF12121A), // Fades into Dark Mode background!
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
      : const LinearGradient(
          colors: [
            Color(0xFFFF8A65),
            Color(0xFFFFCCBC),
            Color(0xFFF9FAFC),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

  // Dynamic Category Pill Backgrounds
  static Color get catBurgerBg => appState.isDarkMode ? const Color(0xFF2A2024) : const Color(0xFFFFEFEB);
  static Color get catPizzaBg => appState.isDarkMode ? const Color(0xFF2A251D) : const Color(0xFFFFF6E5);
  static Color get catSaladBg => appState.isDarkMode ? const Color(0xFF1D2920) : const Color(0xFFEAF9E7);
  static Color get catSoupBg => appState.isDarkMode ? const Color(0xFF2A281E) : const Color(0xFFFFF9E3);

  // Vibrant Orange Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF6A00), Color(0xFFFF4100)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    colors: [Color(0xFFFF5722), Color(0xFFFF7043)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
