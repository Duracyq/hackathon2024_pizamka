import "package:flutter/material.dart";

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: darkColorScheme,
    /*
    ColorScheme.dark(
      inversePrimary: Colors.grey.shade300,
      primary: Colors.grey.shade800,
      secondary: Colors.grey.shade700,
      background: Colors.grey.shade900,
      onPrimary: Colors.white,
      onSecondary: Colors.grey.shade700,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onSecondaryContainer: Colors.white,
    ),
    */
    textTheme: ThemeData.dark()
        .textTheme
        .apply(bodyColor: Colors.grey[300], displayColor: Colors.white));

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFFB1C8),
  onPrimary: Color(0xFF650033),
  primaryContainer: Color(0xFF8E004A),
  onPrimaryContainer: Color(0xFFFFD9E2),
  secondary: Color(0xFFE3BDC6),
  onSecondary: Color(0xFF422931),
  secondaryContainer: Color(0xFF5A3F47),
  onSecondaryContainer: Color(0xFFFFD9E2),
  tertiary: Color(0xFFEFBD94),
  onTertiary: Color(0xFF48290C),
  tertiaryContainer: Color(0xFF623F20),
  onTertiaryContainer: Color(0xFFFFDCC1),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF201A1B),
  onBackground: Color(0xFFEBE0E1),
  surface: Color(0xFF201A1B),
  onSurface: Color(0xFFEBE0E1),
  surfaceVariant: Color(0xFF514347),
  onSurfaceVariant: Color(0xFFD5C2C6),
  outline: Color(0xFF9E8C90),
  onInverseSurface: Color(0xFF201A1B),
  inverseSurface: Color(0xFFEBE0E1),
  inversePrimary: Color(0xFFB90063),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFFFB1C8),
  outlineVariant: Color(0xFF514347),
  scrim: Color(0xFF000000),
);
