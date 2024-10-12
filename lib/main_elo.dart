import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'themes/theme_provider.dart';
import 'themes/dark_mode.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

final Algolia algolia = Algolia.init(
  applicationId: 'YOUR_APP_ID', // Twój App ID z Algolii
  apiKey: 'YOUR_API_KEY', // Twój API Key z Algolii
);

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
            darkTheme: darkMode, // Zakładając, że masz zdefiniowany darkMode
            themeMode: themeProvider.themeMode,
            home: MyHomePage(title: 'cos'),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  List<String> _suggestions = [];

  // Funkcja pobierająca wyniki z Algolii
  Future<void> _getAutocompleteSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    AlgoliaQuery algoliaQuery =
        algolia.instance.index('YOUR_INDEX_NAME').query(query);
    AlgoliaQuerySnapshot snap = await algoliaQuery.getObjects();

    setState(() {
      _suggestions =
          snap.hits.map((hit) => hit.data['name'].toString()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nazwa apki'),
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
      drawer: Drawer(
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
                Navigator.pop(context);
                // Dodaj nawigację do strony głównej
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search'),
              onTap: () {
                Navigator.pop(context);
                // Dodaj nawigację do strony wyszukiwania
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Dodaj nawigację do strony ustawień
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search...',
              ),
              onChanged: (query) {
                _getAutocompleteSuggestions(
                    query); // Autocomplete na zmianę tekstu
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index]),
                    onTap: () {
                      // Możesz dodać akcję po wybraniu sugestii
                      _controller.text = _suggestions[index];
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
