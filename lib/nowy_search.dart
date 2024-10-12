import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class SearchPageNew extends StatefulWidget {
  const SearchPageNew({super.key});

  @override
  State<SearchPageNew> createState() => _SearchPageNewState();
}

class _SearchPageNewState extends State<SearchPageNew> {
  File? _image;
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
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
