import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dark_mode.dart';
import 'light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentThemeData = lightMode;
  String currentThemeKey = 'light';

  ThemeMode get themeMode {
    if (currentThemeKey == 'light') {
      return ThemeMode.light;
    } else if (currentThemeKey == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  ThemeData get themeData {
    return currentThemeData;
  }

  changeTheme(String themeKey, ThemeData themeData) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    await _prefs.setString('theme', themeKey);

    currentThemeKey = themeKey;
    currentThemeData = themeData;
    notifyListeners();
  }

  toggleTheme() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (currentThemeKey == 'light') {
      changeTheme('dark', darkMode);
      await _prefs.setString('theme', 'dark');
    } else {
      changeTheme('light', lightMode);
      await _prefs.setString('theme', 'light');
    }
  }

  initialize() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    currentThemeKey = _prefs.getString('theme') ?? 'system';

    if (currentThemeKey == 'light') {
      currentThemeData = lightMode;
    } else if (currentThemeKey == 'dark') {
      currentThemeData = darkMode;
    } else {
      // Ustaw domyślny motyw systemowy
      currentThemeData = ThemeData.fallback();
    }

    notifyListeners();
  }
}
/*
  Widget buildtheme(BuildContext context) {
    return IconButton(
      icon: Icon(
        Provider.of<ThemeProvider>(context).themeData == darkMode
            ? Icons.nights_stay
            : Icons.wb_sunny,
        size: 30,
        color: Provider.of<ThemeProvider>(context).themeData == darkMode
            ? Colors.white
            : Colors.black,
      ),
      onPressed: () {
        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
      },
    );
  }

*/