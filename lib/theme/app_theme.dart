import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/theme/user_colors.dart';

class AppTheme {
  ThemeData get light {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(backgroundColor: UserColors.blue),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: UserColors.blue,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: UserColors.blue,
            width: 2.0,
          ),
        ),
        labelStyle: TextStyle(
          color: UserColors.blue,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: TextStyle(
          fontWeight: FontWeight.normal,
        ),
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.25,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          color: Color(0xFFABABAB),
          letterSpacing: 1.42,
        ),
        bodySmall: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
