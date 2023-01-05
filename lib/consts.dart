import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

//const pink = Color(0xFFFD2BD76);
const pink = Color(0xFFFA196E);

const coolGrey = Color(0xFFEEEEEE);

//const black = Colors.white;
const black = Colors.black;
//const black87 = Colors.white;
const black87 = Colors.black87;
//const black54 = Colors.white;
const black54 = Colors.black54;
const grey = Colors.grey;
Color lightGrey = Colors.grey.withOpacity(0.5);
Color veryLightGrey = Colors.grey.withOpacity(0.3);
Color transparentBlack = Colors.black.withAlpha(50);

//const white = Colors.black;
const white = Colors.white;
const transparent = Colors.transparent;

void pageScroll(Widget pageName, context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return pageName;
      },
    ),
  );
}

ThemeData kThemeData = ThemeData(
  primaryColor: pink,
  accentColor: white,
  scaffoldBackgroundColor: white,
  fontFamily: "Noto Sans JP",
);

bool web = UniversalPlatform.isWeb;
bool android = UniversalPlatform.isAndroid;
bool ios = UniversalPlatform.isIOS;
