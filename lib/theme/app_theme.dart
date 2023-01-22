import 'package:flutter/material.dart';
import 'package:transport_sterlitamaka/theme/user_colors.dart';

class AppTheme {
  ThemeData get light {
    return ThemeData(
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
        ),
      ),
    );
  }
}
