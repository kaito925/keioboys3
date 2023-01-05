//著作ok

import 'package:flutter/material.dart';
import 'package:Keioboys/consts.dart';

//class RoundIconButton extends StatelessWidget {
//  final IconData icon;
//  final Color iconColor;
//  final double buttonSize;
//  final VoidCallback onPressed;
//  final String imageAsset;
//
//  RoundIconButton.large(
//      {this.icon,
//      this.iconColor,
//      this.buttonSize,
//      this.onPressed,
//      this.imageAsset});
//
////  RoundIconButton.small(
////      {this.icon,
////      this.iconColor,
////      this.buttonSize = 50.0,
////      this.onPressed,
////      this.imageAsset});
//
//  RoundIconButton.tiny(
//      {this.icon,
//      this.iconColor,
//      this.buttonSize = 27.5,
//      this.onPressed,
//      this.imageAsset});
//
//  RoundIconButton.widget(
//      {this.icon,
//      this.iconColor,
//      this.buttonSize = 60.0,
//      this.onPressed,
//      this.imageAsset});
//
//  RoundIconButton({
//    this.icon,
//    this.iconColor,
//    this.buttonSize,
//    this.onPressed,
//    this.imageAsset,
//  });
//
//  @override
//
//IconData icon;
//  final Color iconColor;
//  final double buttonSize;
//  final VoidCallback onPressed;
//  final String imageAsset;

Widget circleButton({
  IconData icon,
  Color color,
  double size,
  VoidCallback onPressed,
  String image,
}) {
//  build(BuildContext context) {
//    Size size = MediaQuery.of(context).size;
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: white,
      boxShadow: [
        BoxShadow(
//          color: pink.withAlpha(50),
          color: Colors.black.withAlpha(50),
          blurRadius: 5.0,
          spreadRadius: 1,
        )
      ],
    ),
    child: (image == null)
        ? RawMaterialButton(
            shape: CircleBorder(),
            elevation: 0.0,
            child: Icon(
              icon,
              color: color,
              size: size * 0.55,
            ),
            onPressed: onPressed,
          )
        : RawMaterialButton(
            shape: CircleBorder(),
            elevation: 0.0,
            child: Image.asset(
              image,
              height: size * 0.55,
              width: size * 0.55,
              color: color,
            ),
            onPressed: onPressed,
          ),
  );
}
