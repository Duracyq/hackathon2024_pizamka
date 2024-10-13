import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'themes/dark_mode.dart';
import 'themes/theme_provider.dart';

class Settings extends StatefulWidget {
  Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool switchValue1 = false;
  bool switchValue2 = false;
  bool switchValue3 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Dodano padding
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Powrót do poprzedniej strony
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Dodano padding
        child: Column(
          children: [
            Center(
              child: Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    Provider.of<ThemeProvider>(context).themeData == darkMode
                        ? Icons.nights_stay
                        : Icons.wb_sunny,
                    size: 45,
                    color: Provider.of<ThemeProvider>(context).themeData ==
                            darkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                  onPressed: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Opcja 1'),
                Switch(
                  value: switchValue1,
                  onChanged: (value) {
                    setState(() {
                      switchValue1 = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Opcja 2'),
                Switch(
                  value: switchValue2,
                  onChanged: (value) {
                    setState(() {
                      switchValue2 = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Opcja 3'),
                Switch(
                  value: switchValue3,
                  onChanged: (value) {
                    setState(() {
                      switchValue3 = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
