import 'package:deadsimplechat_sdk_flutter/deadsimplechat_sdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'drawer.dart';
import 'themes/dark_mode.dart';
import 'themes/theme_provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
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
        child: DeadSimpleChat(
          roomId: 'rcmw6sZSa',
          publicKey:
              'pub_3344556c5778474d2d5a4d486743674c4c53326d314d467836386d6649415f42755f6250594a752d3764426446553733',
          controller: DeadSimpleChatController(),
          onMessage: (message) => print('Message received: $message'),
        ),
      ),
    );
  }
}
