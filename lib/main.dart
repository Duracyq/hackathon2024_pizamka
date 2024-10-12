import 'package:flutter/material.dart';
import 'package:hackathon2024_pizamka/themes/dark_mode.dart';
import 'package:hackathon2024_pizamka/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:deadsimplechat_sdk_flutter/deadsimplechat_sdk_flutter.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return Scaffold(
      appBar: AppBar(
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
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Możesz dodać inne widżety tutaj
          ],
        ),
      ),
    );
  }
}

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

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
