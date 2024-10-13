import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

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
      final data = json.decode(utf8.decode(response.bodyBytes)); // Ensure proper decoding
      setState(() {
        _fetchedText = data['message'];
      });
    } else {
      print('Failed to fetch text');
    }
  }

  List<dynamic> searchResults = []; // To store the fetched results
  String queryTemp = ''; // To store the current search query
  Set<String> uniqueStreets = {}; // Set to store unique streets

  // Function to fetch data from API
  Future<void> fetchData(String query) async {
    final uri = Uri.parse('http://10.0.2.2:8090/api/collections/wywozy/records?filter=(ulica~"$query")');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes)); // Ensure proper decoding

        // Clear the unique streets set for the new query
        uniqueStreets.clear();

        // Store unique streets
        searchResults = data['items'] ?? []; // Assuming the API response contains an 'items' field

        for (var record in searchResults) {
          if (record['ulica'] != null) {
            uniqueStreets.add(record['ulica']); // Add unique street to the set
          }
        }

        setState(() {
          searchResults = uniqueStreets.toList(); // Convert set back to list
        });
      } else {
        print('Failed to fetch data. Reason: ${response.reasonPhrase}'); // Debugging reason for failure
      }
    } catch (e) {
      print('Error fetching data: $e'); // Debugging any exceptions
    }
  }

  String parseDataWywozu(dynamic responseBody) {
    if (responseBody is String) {
      try {
        var parsedData = jsonDecode(responseBody) as List<dynamic>; // Parse as a list
        List<String> formattedDates = []; // To store formatted dates

        for (var timestamp in parsedData) {
          DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000); // Convert timestamp
          String formattedDate = DateFormat('dd-MM-yyyy').format(date); // Format date
          formattedDates.add(formattedDate); // Add to the list
        }

        return formattedDates.join(', '); // Join formatted dates with a comma
      } catch (e) {
        print('Error parsing timestamps: $e');
        return 'Invalid data'; // Handle parsing error
      }
    } else if (responseBody is List) {
      List<String> formattedDates = [];
      for (var timestamp in responseBody) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        String formattedDate = DateFormat('dd-MM-yyyy').format(date);
        formattedDates.add(formattedDate);
      }
      return formattedDates.join(', ');
    } else {
      return 'Invalid data'; // Handle unsupported data type
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchText();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _image == null ? Text('Nie wybrano obrazu.') : Image.file(_image!),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Wybierz obraz'),
          ),
          ElevatedButton(
            onPressed: _uploadImage,
            child: const Text('Prześlij obraz'),
          ),
          TextField(
            onChanged: (value) async {
              if (value.isNotEmpty) {
                queryTemp = value; // Store the current query
                await fetchData(value); // Call the fetchData function on text change
              } else {
                setState(() {
                  searchResults = []; // Clear results if search is empty
                  queryTemp = ''; // Clear the query
                });
              }
            },
            decoration: InputDecoration(
              hintText: 'Szukaj po adresie',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          // Display the search results
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                var streetName = searchResults[index];
                return ListTile(
                  title: Text(streetName),
                  // subtitle: Text(
                  //   '${streetName ?? 'No type'} | ${streetName} != null ? parseDataWywozu(record['timestamps_json']) : 'No date available'}'
                  // ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(_fetchedText),
        ],
      ),
    );
  }
}
