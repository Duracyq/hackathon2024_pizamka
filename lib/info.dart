import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'drawer.dart';
import 'themes/dark_mode.dart';
import 'themes/theme_provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const apiKey = "AIzaSyBUZxLhOwwsm25SeaiXbbYzEgOsnWlTe3s";

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  final TextEditingController _controller = TextEditingController();
  final PageController _cardController = PageController();
  String _responseText = '';
  String prompt = '';
  final List<Map<String, String>> cardData = [
    {
      'image': 'assets/dzieci.png',
      'title': 'Recykling',
      'description':
          'Recykling to proces przetwarzania zużytych materiałów i odpadów na surowce, które mogą być ponownie wykorzystane do produkcji nowych produktów, co pomaga chronić środowisko i zmniejszać ilość odpadów.'
    },
    {
      'image': 'assets/yellow.png',
      'title': 'Żółty',
      'description':
          'Odpady z plastiku i metalu, takie jak butelki, puszki, opakowania wielomateriałowe.'
    },
    {
      'image': 'assets/green.png',
      'title': 'Zielony',
      'description':
          'Odpady szklane, czyli butelki, słoiki i inne produkty ze szkła.'
    },
    {
      'image': 'assets/red.png',
      'title': 'Brązowy',
      'description':
          'Odpady bio, takie jak resztki jedzenia, obierki i inne organiczne materiały.'
    },
    {
      'image': 'assets/blue.png',
      'title': 'Niebieski',
      'description':
          'Odpady papierowe, np. gazety, kartony, zeszyty i inne wyroby papiernicze.'
    },
    {
      'image': 'assets/black.png',
      'title': 'Czarny',
      'description':
          'Odpady zmieszane, których nie można posegregować, takie jak brudne opakowania i resztki tworzyw sztucznych.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadPrompt();
  }

  Future<void> _loadPrompt() async {
    try {
      final loadedPrompt = await rootBundle.loadString('lib/prompt.txt');
      setState(() {
        prompt = loadedPrompt;
      });
    } catch (e) {
      print('Error loading prompt: $e');
    }
  }

  Future<void> _sendRequest() async {
    if (prompt.isEmpty) {
      // Ensure prompt is loaded before sending request
      await _loadPrompt();
    }

    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    final userInput = _controller.text;
    final combinedPrompt = '$prompt $userInput';
    final content = [Content.text(combinedPrompt)];
    final response = await model.generateContent(content);

    setState(() {
      _responseText = response.text!;
      // Assuming the response text contains the index of the card to display
      int cardIndex = int.tryParse(response.text!) ?? 0;
      _cardController.jumpToPage(cardIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Wpisz swój odpad',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _sendRequest,
                child: Text('Zapytaj model'),
              ),
              SizedBox(height: 16),
              //Text(_responseText),
              SizedBox(height: 16),
              Container(
                height: 300,
                child: PageView.builder(
                  controller: _cardController,
                  itemCount: cardData.length,
                  itemBuilder: (context, index) {
                    final card = cardData[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16.0),
                            ),
                            child: Image.asset(
                              card['image']!,
                              height: 150,
                              width: double.infinity,
                              fit: index == 0 ? BoxFit.cover : BoxFit.contain,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              card['title']!,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              card['description']!,
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
