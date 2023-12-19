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

  Future<void> _deleteImage(int index) async {
    final imageInfo = imageList[index];
    final response = await http.post(
      Uri.parse("http://10.10.24.23/flutter_images/delete_image.php"),
      body: {
        "file_name": imageInfo['file_name'],
      },
    );

    if (response.statusCode == 200) {
      print("Image deleted successfully");
    } else {
      print("Failed to delete image: ${response.statusCode}");
    }
    await fetchImages();
  }

  Future<void> _editImage(int index) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    final imageInfo = imageList[index];
    nameController.text = imageInfo['nama'];
    descriptionController.text = imageInfo['description'];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Image'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'New Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'New Description'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog

                final response = await http.post(
                  Uri.parse("http://10.10.24.23/flutter_images/edit_image.php"),
                  body: {
                    "file_name": imageInfo['file_name'],
                    "nama": nameController.text,
                    "description": descriptionController.text,
                  },
                );

                if (response.statusCode == 200) {
                  print("Image details updated successfully");
                } else {
                  print("Failed to update image details: ${response.statusCode}");
                }
                await fetchImages();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editImage(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteImage(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
