import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class GalleryScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFromGallery(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhotoPreviewScreen(imagePath: image.path)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gallery')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _pickFromGallery(context),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: Text('Select from Gallery'),
        ),
      ),
    );
  }
}

// Placeholder for PhotoPreviewScreen
class PhotoPreviewScreen extends StatelessWidget {
  final String imagePath;

  const PhotoPreviewScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo Preview')),
      body: Center(child: Image.file(File(imagePath))),
    );
  }
}
