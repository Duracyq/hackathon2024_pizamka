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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
            SizedBox(height: 16),
            /*
            SizedBox(
              width: screenWidth,
              height: screenHeight - 140, // Consider adjusting this value
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 6,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  double itemHeight = index == 0 ? 120 : 300;

                  if (index == 0) {
                    // First element, the carousel
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: SingleChildScrollView(
                        child: GFCarousel(
                          items: _buildCarouselItems(screenWidth, color),
                          pauseAutoPlayOnTouch: const Duration(seconds: 1),
                          height: itemHeight,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.9,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 8),
                          autoPlayAnimationDuration: const Duration(seconds: 1),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeMainPage: true,
                          hasPagination: true,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    );
                  } else {
                    // Other elements, the post tiles
                    return SizedBox(
                      height: screenHeight - 255,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        //child: _buildPostTile(context),
                      ),
                    );
                  }
                },
              ),
            ),
            */
          ],
        ),
      ),
    );
  }
}
