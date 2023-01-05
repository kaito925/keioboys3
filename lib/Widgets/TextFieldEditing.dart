import 'package:flutter/material.dart';
import 'package:Keioboys/consts.dart';
import 'package:flutter/services.dart';

Widget textFieldEditing({
  String text,
  TextEditingController controller,
  Size size,
  bool readOnly,
}) {
  return TextField(
    controller: controller,
    cursorColor: pink,
    readOnly: readOnly,
    decoration: InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: pink,
          width: size.width * 0.002,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: black87,
          width: size.width * 0.002,
        ),
      ),
      labelText: text,
    ),
    minLines: 1,
    maxLines: 1,
    maxLength: 20,
    maxLengthEnforcement: MaxLengthEnforcement.none,
  );
}

Widget textFieldProfile({
  String text,
  TextEditingController controller,
  Size size,
  bool readOnly,
}) {
  return TextField(
    readOnly: readOnly,
    controller: controller,
    cursorColor: pink,
    decoration: InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: pink,
          width: size.width * 0.002,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: black87,
          width: size.width * 0.002,
        ),
      ),
      labelText: text,
    ),
    minLines: 5,
    maxLines: null,
    maxLength: 500,
    maxLengthEnforcement: MaxLengthEnforcement.none,
  );
}
