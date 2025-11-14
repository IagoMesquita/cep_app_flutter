import 'package:cep_app/shared/ui/cep_app_colors.dart';
import 'package:flutter/material.dart';

sealed class CepAppTheme {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: CepAppColors.primaryColor,
      onPrimary: CepAppColors.primaryColor,
      secondary: CepAppColors.secondaryColor,
      onSecondary: CepAppColors.secondaryColor,
      error: CepAppColors.errorColor,
      onError: CepAppColors.errorColor,
      surface: CepAppColors.lightBgColor,
      onSurface: CepAppColors.lightBgColor,
      // background: CepAppColors.lightBgColor,
      // onBackground: CepAppColors.lightBgColor,
    ),
    // tabBarTheme: TabBarTheme(
    tabBarTheme: TabBarThemeData(
      // unselectedLabelColor: Colors.black.withOpacity(.3),
      unselectedLabelColor: Colors.black.withAlpha((0.3 * 255).round()),
      labelColor: CepAppColors.secondaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: CepAppColors.lightBgColor,
      hintStyle: TextStyle(color: Colors.grey.shade500),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: CepAppColors.primaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: CepAppColors.primaryColor,
      ),
    ),
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.all(Colors.white),
      thumbColor: const MaterialStatePropertyAll(CepAppColors.primaryColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: CepAppColors.primaryColor,
      titleTextStyle: TextStyle(
        color: CepAppColors.secondaryColor,
        fontSize: 16,
      ),
    ),
    scaffoldBackgroundColor: CepAppColors.lightBgColor,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: CepAppColors.blackColor, fontSize: 14),
      titleMedium: TextStyle(color: CepAppColors.blackColor, fontSize: 20),
    ),
  );
}
