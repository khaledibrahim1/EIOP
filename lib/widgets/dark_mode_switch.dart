import 'package:flutter/material.dart';
import '../models/cart_state.dart';

class DarkModeSwitch extends StatelessWidget {
  final Color? headerColor;

  const DarkModeSwitch({super.key, this.headerColor});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final isDark = appState.isDarkMode;
        final baseColor = headerColor ?? const Color(0xFFFF5216);
        // Calculate a deeper recessed shade for the 3D engraved look
        final recessedColor = Color.lerp(baseColor, Colors.black, 0.22)!;

        return GestureDetector(
          onTap: () => appState.toggleDarkMode(),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOutCubic,
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Engraved socket color changes dynamically with header color!
              color: isDark ? const Color(0xFF0F172A) : recessedColor,
              border: Border.all(
                color: isDark
                    ? const Color(0xFFFACC15).withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.22),
                width: 1.5,
              ),
              boxShadow: [
                // Top-Left Inset Shadow Effect (Carved / Engraved look)
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.6)
                      : Colors.black.withValues(alpha: 0.30),
                  blurRadius: 4,
                  offset: const Offset(1.5, 1.5),
                ),
                // Bottom-Right Highlight Edge
                BoxShadow(
                  color: isDark
                      ? const Color(0xFF6366F1).withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.25),
                  blurRadius: 3,
                  offset: const Offset(-1, -1),
                ),
              ],
            ),
            child: Center(
              child: AnimatedRotation(
                turns: isDark ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutBack,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) {
                    return ScaleTransition(
                      scale: anim,
                      child: FadeTransition(opacity: anim, child: child),
                    );
                  },
                  child: Icon(
                    isDark
                        ? Icons.dark_mode_rounded
                        : Icons.wb_sunny_rounded,
                    key: ValueKey<bool>(isDark),
                    size: 19,
                    color: isDark
                        ? const Color(0xFFFACC15)
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
