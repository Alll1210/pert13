import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart';
import 'display_image.dart'; // Import halaman display_image.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageUploadWidget(),
    );
  }
}

class ImageUploadWidget extends StatefulWidget {
  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  File? _imageFile;
  TextEditingController _namaController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      final nama = _namaController.text;
      final description = _descriptionController.text;
      final result = await ApiService.uploadImage(_imageFile!, nama, description);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please take a picture first')));
    }
  }

  // Fungsi untuk menavigasi ke halaman DisplayImagePage
  void _viewImages() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DisplayImagePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload Example'),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _imageFile != null
                  ? Image.file(
                _imageFile!,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              )
                  : Container(
                height: 200,
                width: 200,
                color: Colors.grey,
                child: Icon(Icons.camera_alt, size: 50, color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                child: Text("Take Picture"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text("Upload Image"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _viewImages, // Panggil fungsi _viewImages
                child: Text("View Images"),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
