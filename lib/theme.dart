import 'package:flutter/material.dart';

const ecoGreen = Color(0xFF28783A);
const ecoGreenSoft = Color(0xFFEAF5E6);
const ecoCream = Color(0xFFFBFAF4);
const ecoText = Color(0xFF1F2A22);
const ecoMuted = Color(0xFF7B857D);
const ecoLine = Color(0xFFE7ECE4);

final ecoFitTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: ecoCream,
  colorScheme: ColorScheme.fromSeed(seedColor: ecoGreen, surface: ecoCream),
  fontFamily: 'sans-serif',
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 30,
      height: 1.08,
      fontWeight: FontWeight.w800,
      color: ecoText,
    ),
    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      color: ecoText,
    ),
    titleLarge: TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w800,
      color: ecoText,
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w800,
      color: ecoText,
    ),
    bodyMedium: TextStyle(fontSize: 12, height: 1.45, color: ecoText),
    bodySmall: TextStyle(fontSize: 10, height: 1.4, color: ecoMuted),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: ecoCream,
    foregroundColor: ecoText,
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w800,
      color: ecoText,
    ),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: ecoLine),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: ecoGreen,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      textStyle: const TextStyle(fontWeight: FontWeight.w800),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ecoText,
      minimumSize: const Size.fromHeight(48),
      side: const BorderSide(color: ecoLine),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: ecoLine),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: ecoGreen),
    ),
  ),
);
