import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DisplayImagePage extends StatefulWidget {
  @override
  _DisplayImagePageState createState() => _DisplayImagePageState();
}

class _DisplayImagePageState extends State<DisplayImagePage> {
  List<Map<String, dynamic>> imageList = [];

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    final response = await http.get(Uri.parse("http://10.10.24.23/flutter_images/fetch_images.php"));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        imageList = List<Map<String, dynamic>>.from(jsonData);
      });
    } else {
      // Handle error
      print("Failed to fetch images: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
      ),
      body: ListView.builder(
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          final imageInfo = imageList[index];
          final imageUrl = "http://10.10.24.23/flutter_images/uploads/${imageInfo['file_name']}";

          return ListTile(
            title: Text(imageInfo['nama']),
            subtitle: Text(imageInfo['description']),
            leading: Image.network(
              imageUrl,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
