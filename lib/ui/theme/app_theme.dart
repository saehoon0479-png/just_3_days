import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/spec_constants.dart';

class AppTheme {
  static ThemeData build() {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: SpecConst.bg,
      colorScheme: base.colorScheme.copyWith(
        primary: SpecConst.primary,
        error: SpecConst.error,
        surface: Colors.white,
      ),
      textTheme: GoogleFonts.juaTextTheme(base.textTheme).apply(
        bodyColor: SpecConst.text,
        displayColor: SpecConst.text,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: SpecConst.primary,
          foregroundColor: SpecConst.text,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SpecConst.radius),
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SpecConst.radius),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SpecConst.radius),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
        ),
      ),
    );
  }
}
