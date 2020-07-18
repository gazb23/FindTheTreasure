import 'dart:io';


import 'package:find_the_treasure/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;
  final _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
   final selected = await _picker.getImage(source: source);
    setState(() {
      _imageFile = File(selected.path);
    });
    
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        maxHeight: 512,
        maxWidth: 512,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: MaterialTheme.orange,
            toolbarWidgetColor: Colors.white,
            toolbarTitle: 'Crop image'),
        iosUiSettings: IOSUiSettings(title: 'Crop image'));
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed: () => _pickImage(ImageSource.camera),
          ),
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: () => _pickImage(ImageSource.gallery),
          ),
        ],
      )),
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Image.file(_imageFile),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.crop),
                  onPressed: _cropImage,
                ),
                FlatButton(
                  child: Icon(Icons.clear),
                  onPressed: _clear,
                ),

          
              ],
                
            ),
            
          ]
        ],
      ),
    );
  }
}
