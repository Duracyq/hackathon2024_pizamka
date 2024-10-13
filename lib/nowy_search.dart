import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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
      final data = json.decode(response.body);
      setState(() {
        _fetchedText = data['message'];
      });
    } else {
      print('Failed to fetch text');
    }
  }
  List<dynamic> searchResults = []; // To store the fetched results

  // Function to fetch data from API
  Future<void> fetchData(String query) async {
    //! Update the URI with your API endpoint
    final uri = Uri.parse('http://10.0.2.2:8090/api/collections/wywozy/records?filter=(ulica~"$query")');
    print('Requesting data from: $uri'); // Debugging the URI being requested

    try {
      var request = http.Request('GET', uri);
      http.StreamedResponse response = await request.send();

      // Debugging the response
      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString(); // Get the response body
        print('Response body: $responseBody'); // Debugging the response body

        final data = jsonDecode(responseBody); // Parse the JSON response
        setState(() {
          searchResults = data['items'] ?? []; // Assuming the API response contains an 'items' field
        });
        print('Updated searchResults: $searchResults'); // Debugging the search results after parsing
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
          print('Formatted date: $formattedDate'); // Print each formatted date
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
        print('Formatted date: $formattedDate');
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
          _image == null ? Text('No image selected.') : Image.file(_image!),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Pick Image'),
          ),
          ElevatedButton(
            onPressed: _uploadImage,
            child: const Text('Upload Image'),
          ),
          TextField(
            onChanged: (value) async {
              if (value.isNotEmpty) {
                debugPrint('Search query: $value'); // Debugging the value from the TextField
                await fetchData(value); // Call the fetchData function on text change
              } else {
                debugPrint('Search query cleared.'); // Debugging when search is cleared
                setState(() {
                  searchResults = []; // Clear results if search is empty
                });
              }
            },
            decoration: InputDecoration(
              hintText: 'Search by address',
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
                var record = searchResults[index];
                debugPrint('Displaying record: $record'); // Debugging each record being displayed
                // if(record['timestamps_json'] == null) {
                //   return Container();
                // }
                return ListTile(
                  title: Text(record['ulica'] ?? 'No address'),
                  subtitle: Text(
                    '${record['rodzaj'] ?? 'No type'} | ${record['timestamps_json'] != null ? parseDataWywozu(record['timestamps_json']) : 'No date available'}'
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(_fetchedText),
          /*
            SizedBox(
                width: screenWidth,
                height: screenHeight - 140, // Consider adjusting this value
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
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
              ),*/
        ],
      ),
    );
  }
}
