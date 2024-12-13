import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: AppColors.primaryColor,
    hintColor: AppColors.secondaryColor,
    cardColor: AppColors.errorColor,
    colorScheme: const ColorScheme(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      surface: Colors.white,
      error: AppColors.errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
      labelLarge: TextStyle(color: Colors.white),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
