
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.primaryColor,
      cardColor: AppColors.cardColor,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.textColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
            fontSize: 57, fontWeight: FontWeight.bold, color: AppColors.textColor),
        displayMedium: GoogleFonts.poppins(
            fontSize: 45, fontWeight: FontWeight.bold, color: AppColors.textColor),
        displaySmall: GoogleFonts.poppins(
            fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.textColor),
        headlineLarge: GoogleFonts.poppins(
            fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textColor),
        headlineMedium: GoogleFonts.poppins(
            fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textColor),
        headlineSmall: GoogleFonts.poppins(
            fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textColor),
        titleLarge: GoogleFonts.poppins(
            fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textColor),
        titleMedium: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textColor),
        titleSmall: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textColor),
        bodyLarge: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textColor),
        bodyMedium: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textColor),
        bodySmall: GoogleFonts.poppins(
            fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.secondaryTextColor),
        labelLarge: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textColor),
        labelMedium: GoogleFonts.poppins(
            fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textColor),
        labelSmall: GoogleFonts.poppins(
            fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.secondaryTextColor),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentColor,
        secondary: AppColors.secondaryAccentColor,
        surface: AppColors.cardColor,
        background: AppColors.primaryColor,
        error: AppColors.errorColor,
        onPrimary: AppColors.primaryColor,
        onSecondary: AppColors.primaryColor,
        onSurface: AppColors.textColor,
        onBackground: AppColors.textColor,
        onError: Colors.white,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.accentColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentColor,
          foregroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentColor,
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardColor,
        hintStyle: GoogleFonts.poppins(color: AppColors.secondaryTextColor),
        labelStyle: GoogleFonts.poppins(color: AppColors.textColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:const BorderSide(color: AppColors.accentColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:const BorderSide(color: AppColors.cardColor, width: 1.0),
        ),
      ),
      // cardTheme: CardTheme( // Correction ici: CardTheme est le bon type pour la propri\u00e9t\u00e9 cardTheme
      //   color: AppColors.cardColor,
      //   elevation: 4,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(12.0),
      //   ),
      // ),
      iconTheme: const IconThemeData(
        color: AppColors.textColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentColor,
        foregroundColor: AppColors.primaryColor,
      ),
    );
  }
}
