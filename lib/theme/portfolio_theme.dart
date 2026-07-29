import 'package:flutter/material.dart';

abstract final class PortfolioColors {
  static const background = Color(0xFF060B14);
  static const surface = Color(0xFF0D1422);
  static const surfaceLight = Color(0xFF131D2E);
  static const primary = Color(0xFF4DE3F2);
  static const secondary = Color(0xFF7C6CFF);
  static const accent = Color(0xFFB6FF6A);
  static const text = Color(0xFFF5F7FB);
  static const muted = Color(0xFF95A2B8);
  static const border = Color(0x1FFFFFFF);
}

abstract final class PortfolioTheme {
  static ThemeData dark({required bool isArabic}) {
    final base = ThemeData.dark(useMaterial3: true);
    const radius = BorderRadius.all(Radius.circular(14));

    return base.copyWith(
      scaffoldBackgroundColor: PortfolioColors.background,
      colorScheme: const ColorScheme.dark(
        primary: PortfolioColors.primary,
        secondary: PortfolioColors.secondary,
        surface: PortfolioColors.surface,
        error: Color(0xFFFF647C),
      ),
      textTheme: base.textTheme.apply(
        fontFamily: isArabic ? 'Cairo' : null,
        bodyColor: PortfolioColors.text,
        displayColor: PortfolioColors.text,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.035),
        labelStyle: const TextStyle(color: PortfolioColors.muted),
        hintStyle: TextStyle(
          color: PortfolioColors.muted.withValues(alpha: 0.55),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: const OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: PortfolioColors.border),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: PortfolioColors.border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: PortfolioColors.primary,
            width: 1.4,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: PortfolioColors.primary,
          foregroundColor: PortfolioColors.background,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: PortfolioColors.text,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
          side: const BorderSide(color: PortfolioColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: PortfolioColors.surface,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      dividerColor: PortfolioColors.border,
    );
  }
}

class PortfolioPanel extends StatelessWidget {
  const PortfolioPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.radius = 24,
    this.gradient,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Gradient? gradient;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? PortfolioColors.surface : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? PortfolioColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: child,
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.style,
    this.gradient = const LinearGradient(
      colors: [PortfolioColors.primary, PortfolioColors.secondary],
    ),
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Text(text, style: style),
    );
  }
}
