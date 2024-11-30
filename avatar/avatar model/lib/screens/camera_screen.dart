import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto(BuildContext context) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhotoPreviewScreen(imagePath: photo.path)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _takePhoto(context),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text('Take Photo'),
        ),
      ),
    );
  }
}

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
