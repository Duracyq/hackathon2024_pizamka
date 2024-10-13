import 'package:flutter/material.dart';
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
  String _responseText = '';

  Future<void> _sendRequest() async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    final prompt =
        "Napisz w jednym wyrazie kolor smietnika do ktorego powinienem wrzuc moj smiec";
    final userInput = _controller.text;
    final combinedPrompt = '$prompt $userInput';
    final content = [Content.text(combinedPrompt)];
    final response = await model.generateContent(content);

    setState(() {
      _responseText = response.text!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info Page'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter your text here',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendRequest,
              child: Text('Send Request'),
            ),
            SizedBox(height: 16),
            Text(_responseText),
          ],
        ),
      ),
    );
  }
}
