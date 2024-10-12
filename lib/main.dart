import 'package:flutter/material.dart';
import 'package:hackathon2024_pizamka/themes/dark_mode.dart';
import 'package:hackathon2024_pizamka/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:deadsimplechat_sdk_flutter/deadsimplechat_sdk_flutter.dart';

import 'drawer.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Hackathon Plock 2024',
            theme: themeProvider.themeData,
            darkTheme: darkMode,
            themeMode: themeProvider.themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
