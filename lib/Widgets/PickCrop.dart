import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'cropper_screen.dart';
import 'utils.dart';
import 'cropper_screen_fake.dart' if (dart.library.js) 'cropper_screen.dart'
    as cropper_screen;

Future<Uint8List> pickAndCrop({context, mounted, ratio}) async {
  Uint8List photoWeb;
  final picker = ImagePicker();
  XFile pickedFile = await picker.pickImage(source: ImageSource.gallery);

//  if (pickedFile != null) {
  if (mounted && pickedFile != null) {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => cropper_screen.CropperScreen(
//            pickedFile.path,
            imagePath: pickedFile.path,
            ratio: ratio,
          ),
        ));
    if (result != null) {
      photoWeb = await getBlobData(result);
//      if (mounted) {
//        setState(() {});
//      }
    }
  }
  return photoWeb;
}
