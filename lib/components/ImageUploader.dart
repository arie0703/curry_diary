import 'package:flutter/material.dart';
import 'package:curry_app/ImageStatus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class ImageUploader extends StatefulWidget {
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  File? _selectedImage;
  Future<void> _upload() async {
    // imagePickerで画像を選択する
    final PickedFile? pickerFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    File file = File(pickerFile!.path);

    setState(() {
      _selectedImage = file;
    });

    context.read<ImageStatus>().setImage(_selectedImage);
  }

  @override
  Widget build(BuildContext context) {
    return (Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              width: 300,
              child: _selectedImage == null
                  ? Text('No image selected.')
                  : Image.file(_selectedImage!)),
        ),
        ElevatedButton(
            onPressed: () {
              _upload();
              debugPrint(_selectedImage.toString());
            },
            child: Text("upload")),
      ],
    ));
  }
}
