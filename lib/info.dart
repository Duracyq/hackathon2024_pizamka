import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'drawer.dart';
import 'themes/dark_mode.dart';
import 'themes/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
        scrolledUnderElevation: 4,
        shadowColor: Theme.of(context).colorScheme.shadow,
        actions: [
          Builder(
            builder: (context) => IconButton(
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
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Settings Page'),
      ),
    );
  }
}
