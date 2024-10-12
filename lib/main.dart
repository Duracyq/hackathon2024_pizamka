import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Algolia Autocomplete"),
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
