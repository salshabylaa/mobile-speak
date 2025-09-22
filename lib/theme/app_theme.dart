import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFAC1754);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white, 
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: Colors.white, 
        ),
      ),
    );
  }
}