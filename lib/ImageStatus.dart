import 'package:flutter/material.dart';
import 'dart:io';

class ImageStatus with ChangeNotifier {
  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  void setImage(image) {
    _selectedImage = image;
    notifyListeners();
  }
}
