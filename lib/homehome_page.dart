import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hackathon2024_pizamka/event_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeHomePage extends StatefulWidget {
  const HomeHomePage({super.key});

  @override
  State<HomeHomePage> createState() => _HomeHomePageState();
}

class _HomeHomePageState extends State<HomeHomePage> {
  // Przykładowa lista danych
  void _navigateToAnotherPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventList()),
    );
  }

  List<dynamic> searchResults = []; // To store the fetched results
  String queryTemp = ''; // To store the current search query
  Set<String> uniqueStreets = {}; // Set to store unique streets

  // Function to fetch data from API
  Future<void> fetchData(String query) async {
    final uri = Uri.parse(
        'http://10.0.2.2:8090/api/collections/wywozy/records?filter=(ulica~"$query")');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(
            utf8.decode(response.bodyBytes)); // Ensure proper decoding

        // Clear the unique streets set for the new query
        uniqueStreets.clear();

        // Store unique streets
        searchResults = data['items'] ??
            []; // Assuming the API response contains an 'items' field

        for (var record in searchResults) {
          if (record['ulica'] != null) {
            uniqueStreets.add(record['ulica']); // Add unique street to the set
          }
        }

        setState(() {
          searchResults = uniqueStreets.toList(); // Convert set back to list
        });
      } else {
        print(
            'Failed to fetch data. Reason: ${response.reasonPhrase}'); // Debugging reason for failure
      }
    } catch (e) {
      print('Error fetching data: $e'); // Debugging any exceptions
    }
  }

  String parseDataWywozu(dynamic responseBody) {
    if (responseBody is String) {
      try {
        var parsedData =
            jsonDecode(responseBody) as List<dynamic>; // Parse as a list
        List<String> formattedDates = []; // To store formatted dates

        for (var timestamp in parsedData) {
          DateTime date = DateTime.fromMillisecondsSinceEpoch(
              timestamp * 1000); // Convert timestamp
          String formattedDate =
              DateFormat('dd-MM-yyyy').format(date); // Format date
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          
          TextField(
            onChanged: (value) async {
              if (value.isNotEmpty) {
                queryTemp = value; // Store the current query
                await fetchData(
                    value); // Call the fetchData function on text change
              } else {
                setState(() {
                  searchResults = []; // Clear results if search is empty
                  queryTemp = ''; // Clear the query
                });
              }
            },
            decoration: InputDecoration(
              hintText: 'Wyszukaj lokalizację',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          // Display the search results
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              var streetName = searchResults[index];
              return ListTile(
                title: Text(streetName),
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _navigateToAnotherPage,
            child: Text('Go to List Event Page'),
          ),
        ],
      ),
    );
  }
}
