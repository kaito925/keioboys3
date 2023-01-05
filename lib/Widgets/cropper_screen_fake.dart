import 'package:flutter/material.dart';

class CropperScreen extends StatefulWidget {
  final String imagePath;
  final double ratio;
//  const CropperScreen(this.imagePath, {Key key}) : super(key: key);
  const CropperScreen({this.imagePath, this.ratio, Key key}) : super(key: key);

  @override
  _CropperScreenState createState() => _CropperScreenState();
}

class _CropperScreenState extends State<CropperScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
