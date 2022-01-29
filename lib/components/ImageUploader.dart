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
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (_selectedImage != null)
            Container(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                width: 120,
                height: 120,
                child: Image.file(_selectedImage!, fit: BoxFit.cover)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              width: 120,
              height: 120,
              child: ElevatedButton(
                onPressed: () {
                  _upload();
                },
                child: const Icon(Icons.add_a_photo, color: Colors.black38),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange[50],
                  elevation: 0,
                ),
              )),
        ],
      ),
    );
  }
}
