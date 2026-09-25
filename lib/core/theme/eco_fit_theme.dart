import 'package:flutter/material.dart';

const ecoGreen = Color(0xFF245C3D);
const ecoLeaf = Color(0xFF6F8F4E);
const ecoClay = Color(0xFFC96F4A);
const ecoSun = Color(0xFFE4B95F);
const ecoGreenSoft = Color(0xFFE4EDDF);
const ecoCream = Color(0xFFF6F3EA);
const ecoPaper = Color(0xFFFFFDF8);
const ecoText = Color(0xFF173126);
const ecoMuted = Color(0xFF68766F);
const ecoLine = Color(0xFFDCE3DA);

// Dark palette mirrors the Eco Fit web dashboard instead of Material's
// generated dark colors. Keep these semantic values shared across platforms.
const ecoDarkBackground = Color(0xFF121915);
const ecoDarkSurface = Color(0xFF1B261F);
const ecoDarkSurfaceSubtle = Color(0xFF223027);
const ecoDarkBorder = Color(0xFF2E4133);
const ecoDarkLine = Color(0xFF2A3C2F);
const ecoDarkText = Color(0xFFF0F7F2);
const ecoDarkTextSubtle = Color(0xFFD3E2D6);
const ecoDarkMuted = Color(0xFF9BB0A1);
const ecoDarkGreen = Color(0xFF48C369);
const ecoDarkGreenSoft = Color(0xFF183321);

final ecoFitTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: ecoCream,
  colorScheme: ColorScheme.fromSeed(
    seedColor: ecoGreen,
    surface: ecoPaper,
    primary: ecoGreen,
    secondary: ecoLeaf,
  ),
  fontFamily: 'Segoe UI',
  fontFamilyFallback: const ['Roboto', 'Arial'],
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
    bodyLarge: TextStyle(fontSize: 15, height: 1.5, color: ecoText),
    bodyMedium: TextStyle(fontSize: 14, height: 1.45, color: ecoText),
    bodySmall: TextStyle(fontSize: 12, height: 1.4, color: ecoMuted),
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
    color: ecoPaper,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: ecoLine),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: ecoGreen,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontWeight: FontWeight.w800),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ecoText,
      minimumSize: const Size.fromHeight(48),
      side: const BorderSide(color: ecoLine),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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

final ecoFitDarkTheme = ecoFitTheme.copyWith(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: ecoDarkBackground,
  colorScheme: const ColorScheme.dark(
    primary: ecoDarkGreen,
    onPrimary: Color(0xFF071B0D),
    primaryContainer: ecoDarkGreenSoft,
    onPrimaryContainer: Color(0xFF7CE598),
    secondary: Color(0xFF5CD07B),
    onSecondary: Color(0xFF071B0D),
    surface: ecoDarkSurface,
    onSurface: ecoDarkText,
    surfaceContainerHighest: ecoDarkSurfaceSubtle,
    onSurfaceVariant: ecoDarkMuted,
    outline: ecoDarkBorder,
    outlineVariant: ecoDarkLine,
    error: Color(0xFFF87171),
  ),
  textTheme: ecoFitTheme.textTheme.apply(
    bodyColor: ecoDarkText,
    displayColor: ecoDarkText,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: ecoDarkBackground,
    foregroundColor: ecoDarkText,
    elevation: 0,
    scrolledUnderElevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w800,
      color: ecoDarkText,
    ),
  ),
  cardTheme: CardThemeData(
    color: ecoDarkSurface,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: ecoDarkBorder),
    ),
  ),
  dividerColor: ecoDarkLine,
  dividerTheme: const DividerThemeData(color: ecoDarkLine, thickness: 1),
  iconTheme: const IconThemeData(color: ecoDarkTextSubtle),
  listTileTheme: const ListTileThemeData(
    iconColor: ecoDarkGreen,
    textColor: ecoDarkText,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: ecoDarkSurfaceSubtle,
    selectedColor: ecoDarkGreenSoft,
    disabledColor: ecoDarkSurface,
    labelStyle: const TextStyle(color: ecoDarkTextSubtle),
    secondaryLabelStyle: const TextStyle(color: ecoDarkText),
    side: const BorderSide(color: ecoDarkBorder),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: ecoDarkSurface,
    surfaceTintColor: Colors.transparent,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: ecoDarkSurface,
    modalBackgroundColor: ecoDarkSurface,
    surfaceTintColor: Colors.transparent,
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: ecoDarkSurfaceSubtle,
    contentTextStyle: TextStyle(color: ecoDarkText),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: ecoDarkGreen,
    linearTrackColor: ecoDarkSurfaceSubtle,
    circularTrackColor: ecoDarkSurfaceSubtle,
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? ecoDarkGreen
          : Colors.transparent,
    ),
    checkColor: const WidgetStatePropertyAll(Color(0xFF071B0D)),
    side: const BorderSide(color: ecoDarkMuted, width: 2),
  ),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Color(0xFF16211A),
    indicatorColor: ecoDarkGreenSoft,
    iconTheme: WidgetStatePropertyAll(IconThemeData(color: ecoDarkMuted)),
    labelTextStyle: WidgetStatePropertyAll(
      TextStyle(color: ecoDarkMuted, fontSize: 10),
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith(
      (states) =>
          states.contains(WidgetState.selected) ? Colors.white : ecoDarkMuted,
    ),
    trackColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? ecoDarkGreen
          : ecoDarkSurfaceSubtle,
    ),
    trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: ecoDarkGreen,
      foregroundColor: const Color(0xFF071B0D),
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontWeight: FontWeight.w800),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ecoDarkText,
      minimumSize: const Size.fromHeight(48),
      side: const BorderSide(color: ecoDarkBorder),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: ecoDarkSurface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: ecoDarkBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: ecoDarkGreen),
    ),
  ),
);
