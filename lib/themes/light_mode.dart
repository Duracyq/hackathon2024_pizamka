import "package:flutter/material.dart";

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  //ColorScheme.light(
  /*
    inversePrimary: Colors.grey.shade300,
    primary: Colors.grey.shade200,
    secondary: Colors.grey.shade400,
    background: Colors.grey.shade300,
    onPrimary: Colors.black,
    onSecondary: Colors.grey.shade400,
    onSurface: Colors.black,
    onBackground: Colors.black,
    */
  //),
  textTheme: ThemeData.light()
      .textTheme
      .apply(bodyColor: Colors.grey[800], displayColor: Colors.black)
      .copyWith(
        labelLarge: TextStyle(color: Colors.black),
      ),
);

// Theme.of(context).colorScheme.onSecondary,

// Provider.of<ThemeProvider>(context).themeData == darkMode
//             ? Colors.red[400]
//             : Colors.red[700],

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFB90063),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFFD9E2),
  onPrimaryContainer: Color(0xFF3E001D),
  secondary: Color(0xFF74565F),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFFFD9E2),
  onSecondaryContainer: Color(0xFF2B151C),
  tertiary: Color(0xFF7C5635),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFDCC1),
  onTertiaryContainer: Color(0xFF2E1500),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFFFBFF),
  onBackground: Color(0xFF201A1B),
  surface: Color(0xFFFFFBFF),
  onSurface: Color(0xFF201A1B),
  surfaceVariant: Color(0xFFF2DDE1),
  onSurfaceVariant: Color(0xFF514347),
  outline: Color(0xFF837377),
  onInverseSurface: Color(0xFFFAEEEF),
  inverseSurface: Color(0xFF352F30),
  inversePrimary: Color(0xFFFFB1C8),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFB90063),
  outlineVariant: Color(0xFFD5C2C6),
  scrim: Color(0xFF000000),
);
