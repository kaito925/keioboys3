import 'package:flutter/material.dart';
import 'package:Keioboys/consts.dart';

Widget textField(controller, text, size) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: text,
      labelStyle: TextStyle(
        color: black87,
        fontSize: size.width * 0.07,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: black87,
          width: size.width * 0.002,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: black87,
          width: size.width * 0.002,
        ),
      ),
    ),
  );
}
