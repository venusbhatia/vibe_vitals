import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';

class AppTheme {
  static const Color primaryColor = Color(0xFF3D7AFF);
  static const Color secondaryColor = Color(0xFF58C8F4);
  static const Color accentColor = Color(0xFFFF6B8B);
  static const Color tertiaryColor = Color(0xFFAE8BFF);
  static const Color backgroundColor = Color(0xFFF8F9FF);
  static const Color cardColor = Colors.white;
  static const Color glassColor = Color(0xDDFFFFFF);
  static const Color textPrimaryColor = Color(0xFF2C3550);
  static const Color textSecondaryColor = Color(0xFF8E92A4);
  static const Color errorColor = Color(0xFFFF5A65);
  static const Color successColor = Color(0xFF4CD964);
  static const Color warningColor = Color(0xFFFFBF47);
  static const Color dividerColor = Color(0xFFE8EAF6);

  static BoxDecoration glassDecoration({
    double borderRadius = 16,
    Color borderColor = Colors.white30,
    double opacity = 0.7,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor, width: 0.5),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(opacity + 0.1),
          Colors.white.withOpacity(opacity),
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          spreadRadius: 0,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  static ThemeData lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        background: backgroundColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      useMaterial3: true,
      fontFamily: '.SF Pro Display',
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimaryColor,
        titleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: '.SF Pro Display',
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: primaryColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: primaryColor.withOpacity(0.3),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: cardColor,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: -0.3,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        splashColor: Colors.white.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 34,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 28,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          color: textPrimaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 22,
          letterSpacing: -0.3,
        ),
        titleMedium: TextStyle(
          color: textPrimaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 17,
          letterSpacing: -0.3,
        ),
        bodyLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 17,
          letterSpacing: -0.3,
        ),
        bodyMedium: TextStyle(
          color: textSecondaryColor,
          fontSize: 15,
          letterSpacing: -0.2,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 0.5,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: const TextStyle(color: textSecondaryColor),
        hintStyle: TextStyle(color: textSecondaryColor.withOpacity(0.7)),
      ),
      iconTheme: const IconThemeData(
        color: primaryColor,
        size: 24,
      ),
      brightness: Brightness.light,
    );
  }

  static ThemeData darkTheme() {
    return lightTheme();
  }
} 