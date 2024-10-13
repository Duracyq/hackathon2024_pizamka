import 'package:flutter/material.dart';

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  // Przykładowa lista wydarzeń
  final List<Map<String, String>> events = [
    {
      'title': 'Zbiórka elektrośmieci',
      'description': 'Na rogu ulicy Słonecznej i Wesołej.',
      'date': '2023-10-01',
      'imageUrl': 'assets/1.png',
    },
    {
      'title': 'Zakup 10 nowych śmieciarek',
      'description': 'Kolejne dofinansowanie z UE.',
      'date': '2023-10-05',
      'imageUrl': 'assets/2.jpg',
    },
    {
      'title': 'Wystawa sztuki nowoczesnej z wykorzystaniem śmieci',
      'description': 'Impreza odbędzie sie w Muzeum Sztuki Nowoczesnej.',
      'date': '2023-10-10',
      'imageUrl': 'assets/3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Wydarzeń'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*
                  Image.network(
                    event['imageUrl']!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  */
                  Image.asset(
                    event['imageUrl']!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text(
                    event['title']!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    event['description']!,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Data: ${event['date']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
