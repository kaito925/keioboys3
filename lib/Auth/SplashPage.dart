import 'package:flutter/material.dart';
import '../consts.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          child: Center(
            child:
//        ClipRRect(
//                borderRadius: BorderRadius.circular(size.width * 0.15),
//            child:
//            Image.asset(
//              'assets/appiconv9.png',
//              height: size.height * 0.2,
//              width: size.height * 0.2,
//            ),
//          ),
                Text(
              "Keioboys",
              style: TextStyle(
                fontFamily: 'DancingScript',
                fontSize: size.width * 0.2,
                color: pink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
