import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reading_book_app/app/config/app_colors.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  fontFamily: GoogleFonts.unbounded().fontFamily,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black87),
    titleTextStyle: TextStyle(color: AppColors.lightPrimary, fontSize: 24),
  ),
  colorScheme: const ColorScheme.light(
    primary: Colors.black87,
    secondary: AppColors.lightSecondary,
    tertiary: AppColors.lightTertiary,
  ),
  scaffoldBackgroundColor: AppColors.colorBlack,
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.lightSecondary,
      ),
    ),
    floatingLabelStyle: TextStyle(color: AppColors.lightSecondary),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.pressed) ? AppColors.light : AppColors.blackNeutral;
      }),
      iconColor: WidgetStateProperty.all<Color>(
        AppColors.blackNeutral,
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return AppColors.blackNeutral;
        }
        return AppColors.light;
      }),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStateProperty.all<TextStyle>(
        const TextStyle(
          fontSize: 16,
          color: AppColors.light,
          fontWeight: FontWeight.w700,
        ),
      ),
      side: WidgetStateProperty.all<BorderSide>(
        const BorderSide(
          color: AppColors.light,
          width: 1,
        ),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStateProperty.all<TextStyle>(
        TextStyle(
          fontSize: 12,
          foreground: Paint()..color = AppColors.light,
        ),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.red.shade900;
        }
        return AppColors.lightPrimary;
      }),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.red.shade900;
        }
        return AppColors.light;
      }),
      foregroundColor: WidgetStateProperty.all<Color>(AppColors.light),
      iconSize: WidgetStateProperty.all<double>(20),
      iconColor: WidgetStateProperty.all<Color>(Colors.white),
      padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(8)),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      side: const BorderSide(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Border radius of 16
      ),
    ),
  ),
  textTheme: const TextTheme(
    labelSmall: TextStyle(color: AppColors.light),
    labelMedium: TextStyle(color: AppColors.light),
    labelLarge: TextStyle(color: AppColors.light),
    titleLarge: TextStyle(
      color: AppColors.light,
      fontSize: 32,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      color: AppColors.light,
      fontSize: 24,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      color: AppColors.light,
    ),
    bodyLarge: TextStyle(
      color: AppColors.light,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(
      color: AppColors.light,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: TextStyle(
      color: AppColors.light,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    displaySmall: TextStyle(
      color: AppColors.light,
      fontSize: 12,
    ),
  ),
  cardTheme: const CardThemeData(
    margin: EdgeInsets.zero, // Remove default margin
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.light,
  ),
);
