import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hackathon2024_pizamka/event_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your username',
            ),
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
