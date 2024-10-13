import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class EventList extends StatefulWidget {
  final String query;
  const EventList({super.key, required this.query});


  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  void initState() {
    super.initState();
    fetchEvents();
  }
  // final List<Map<String, dynamic>> data = [
  //   {'name': 'BIO', 'number': 13},
  //   {'name': 'Plastik', 'number': 4},
  //   {'name': 'Papier', 'number': 2},
  //   {'name': 'Zmieszane', 'number': 4},
  //   {'name': 'Szkło', 'number': 7},
  //   {'name': 'Meble i gabaryty', 'number': 28},
  // ];
  void _navigateToAnotherPage() {
    Navigator.pop(context);
  }
  List<dynamic> eventList = [];

  Future<List<Map<String, dynamic>>> fetchEvents() async {
    final uri = Uri.parse('http://10.0.2.2:8090/api/collections/wywozy/records?filter=(ulica~"${widget.query}")');  // Replace with your dynamic query if needed
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        // Check if 'items' is available in the response
        if (data is Map<String, dynamic> && data.containsKey('items')) {
          return List<Map<String, dynamic>>.from(data['items']);
        } else {
          print('Unexpected response structure: $data');
          return [];
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [];
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Harmonogram wywozu odpadów'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _navigateToAnotherPage,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: [
              Text(
                'Zbiórka na ulicy ${widget.query}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchEvents(), // Your future function
                  builder: (context, snapshot) {
                    // Check the state of the snapshot
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While waiting for the data, show a loading indicator
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      // In case of an error
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      // If there's no data
                      return const Center(child: Text('No data found'));
                    } else {
                      // Once data is available, build the GridView
                      final data = snapshot.data!;
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Adjust columns here
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: 2,
                        ),
                        itemCount: data.length, // Set item count based on data length
                        itemBuilder: (context, index) {
                          final item = data[index];

                          // Safely access 'ulica', 'rodzaj', and timestamps
                          // final String street = item['ulica'] ?? 'Unknown Street';
                          final String type = item['rodzaj'] ?? 'Unknown Type';
                          final List<dynamic> timestamps = item['timestamps_json'] ?? [];

                          String formattedDate = parseDataWywozu(timestamps);

                          return Card(
                            color: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    type,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                 
                                  if (timestamps.isNotEmpty)
                                    Text(
                                      '${formattedDate}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  else
                                    const Text(
                                      'Brak wywozów w najbliższym czasie',
                                      style: TextStyle(fontSize: 10, color: Colors.red),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
