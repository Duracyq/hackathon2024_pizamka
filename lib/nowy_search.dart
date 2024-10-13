import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'info.dart';

class SearchPageNew extends StatefulWidget {
  const SearchPageNew({super.key});

  @override
  State<SearchPageNew> createState() => _SearchPageNewState();
}

class _SearchPageNewState extends State<SearchPageNew> {
  File? _image;
  String URL_JS_API = 'http://127.0.0.1:8090';

  String _fetchedText = 'Brak danych';

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  final List<Map<String, String>> cardData = [
    {
      'image': 'https://via.placeholder.com/150',
      'title': 'Tytuł 1',
      'description': 'Opis karty 1. To jest przykładowy opis dla karty numer 1.'
    },
    {
      'image': 'https://via.placeholder.com/150',
      'title': 'Tytuł 2',
      'description': 'Opis karty 2. To jest przykładowy opis dla karty numer 2.'
    },
    {
      'image': 'https://via.placeholder.com/150',
      'title': 'Tytuł 3',
      'description': 'Opis karty 3. To jest przykładowy opis dla karty numer 3.'
    },
    {
      'image': 'https://via.placeholder.com/150',
      'title': 'Tytuł 4',
      'description': 'Opis karty 4. To jest przykładowy opis dla karty numer 4.'
    },
    {
      'image': 'https://via.placeholder.com/150',
      'title': 'Tytuł 5',
      'description': 'Opis karty 5. To jest przykładowy opis dla karty numer 5.'
    },
    {
      'image': 'https://via.placeholder.com/150',
      'title': 'Tytuł 6',
      'description': 'Opis karty 6. To jest przykładowy opis dla karty numer 6.'
    },
  ];
  Future<void> _uploadImage() async {
    if (_image == null) return;

    final uri = Uri.parse('https://yourapi.com/upload');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', _image!.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Image upload failed');
    }
  }

  Future<void> _fetchText() async {
    final uri = Uri.parse('https://yourapi.com/get-text');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json
          .decode(utf8.decode(response.bodyBytes)); // Ensure proper decoding
      setState(() {
        _fetchedText = data['message'];
      });
    } else {
      print('Failed to fetch text');
    }
  }

  String _responseMessage = ""; // Variable to hold the response from the API

  Future<void> uploadImage(File imageFile) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:8000/api/upload/'));
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        // Read the response from the API
        final responseBody = await http.Response.fromStream(response);
        final Map<String, dynamic> data =
            json.decode(responseBody.body); // Decode the JSON response

        setState(() {
          // Update the state with the response message
          _responseMessage =
              data['bin_suggestion'] ?? "No suggestion received.";
        });
      } else {
        setState(() {
          _responseMessage = "Failed to upload image.";
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = "Error: $e"; // Update state in case of an error
      });
    }
  }

  void pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      setState(() {
        _image = image;
      });
      await uploadImage(image);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchText();
  }

  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final PageController _cardController = PageController();
  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      /*
      appBar: AppBar(
        title: const Text('Wyszukiwarka odpadów'),
      ),
      */
      body: Column(
        children: [
          CustomSlidingSegmentedControl<int>(
            initialValue: 0,
            fixedWidth: 150,
            children: {
              0: Text('Obraz'),
              1: Text('Tekst'),
            },
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[800]
                  : CupertinoColors.lightBackgroundGray,
              borderRadius: BorderRadius.circular(8),
            ),
            thumbDecoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[600]
                  : Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.3),
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                  offset: Offset(
                    0.0,
                    2.0,
                  ),
                ),
              ],
            ),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInToLinear,
            onValueChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Center(
                          child: _image == null
                              ? Text('Nie wybrano obrazu.')
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      16.0), // Zaokrąglone rogi
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3), // cieniowanie
                                        ),
                                      ],
                                    ),
                                    child: Image.file(_image!),
                                  ),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: pickAndUploadImage,
                                child: const Text('Wybierz obraz'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Mniej zaokrąglone rogi
                                  ),
                                  elevation: 5,
                                  shadowColor:
                                      isDarkTheme ? Colors.black : Colors.grey,
                                ),
                              ),
                              // ElevatedButton(
                              //   onPressed: _uploadImage,
                              //   child: const Text('Prześlij obraz'),
                              //   style: ElevatedButton.styleFrom(
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(
                              //           8.0), // Mniej zaokrąglone rogi
                              //     ),
                              //     elevation: 5,
                              //     shadowColor:
                              //         isDarkTheme ? Colors.black : Colors.grey,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        // TextField(
                        //   decoration: InputDecoration(
                        //     hintText: '',
                        //     prefixIcon: const Icon(Icons.search),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 20),
                        Text(
                          _responseMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        Container(
                            height: 300,
                            child: PageView.builder(
                                controller: _cardController,
                                itemCount: 6,
                                itemBuilder: (context, index) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    elevation: 5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16.0),
                                          ),
                                          child: Image.network(
                                            'https://via.placeholder.com/150',
                                            height: 150,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Tytuł $index',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            'Opis karty $index. To jest przykładowy opis dla karty numer $index.',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Info(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
