import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/dark_mode.dart';
import '../themes/theme_provider.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Home Page'),
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
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ),
      ],
    );
  }
}
