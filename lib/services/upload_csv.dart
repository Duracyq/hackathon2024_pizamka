import 'dart:convert';
import 'dart:io';
// import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<bool> checkForDuplicates(String street, String date) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('harmonogram')
      .where('street', isEqualTo: street)
      .where('date', isEqualTo: date)
      .get();

  return querySnapshot.docs.isNotEmpty;
}

Future<List<Map<String, String>>> loadCSVData(String filePath) async {
  final input = File(filePath).openRead();
  final fields = await input
      .transform(utf8.decoder)
      .transform(const CsvToListConverter())
      .toList();

  List<Map<String, String>> data = [];
  // Assuming your CSV's first row contains headers
  List<String> headers = fields.first.map((e) => e.toString()).toList();

  for (var i = 1; i < fields.length; i++) {
    Map<String, String> row = {};
    for (var j = 0; j < headers.length; j++) {
      row[headers[j]] = fields[i][j].toString();
    }
    data.add(row);
  }

  return data;
}


Future<void> insertDataToFirestore(String street, String date, String type) async {
  await FirebaseFirestore.instance.collection('harmonogram').add({
    'street': street,
    'date': date,
    'type': type,
  });
}


Future<void> processCSVAndUpload(String filePath) async {
  List<Map<String, String>> csvData = await loadCSVData(filePath);

  for (var row in csvData) {
    String street = row['Adres'] ?? '';
    String date = row['Data wywozu'] ?? '';
    String type = row['Rodzaj wywozu'] ?? '';

    // Check for duplicates before inserting
    bool isDuplicate = await checkForDuplicates(street, date);

    if (!isDuplicate) {
      await insertDataToFirestore(street, date, type);
      debugPrint('Inserted: $street, $date, $type');
    } else {
      debugPrint('Duplicate found, skipping: $street, $date');
    }
  }
}
