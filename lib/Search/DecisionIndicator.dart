import 'package:flutter/material.dart';
import 'package:Keioboys/Search/PhotoIndicator.dart';
import 'package:Keioboys/Widgets/CalculateAge.dart';
import 'package:Keioboys/consts.dart';

Widget skipIndicator(size) {
  // NOPEにふったときのエフェクトのNOPE
  return Align(
    alignment: Alignment.topRight,
    child: Transform.rotate(
      angle: 270.0,
      origin: Offset(
        size.width * 0.55,
        size.height * 0.2,
      ),

//        child: Stack(
//          children: <Widget>[
//            Container(
//              height: size.height * 0.1,
//              width: size.height * 0.26,
//              decoration: BoxDecoration(
////                color: Colors.white38,
//                borderRadius: BorderRadius.circular(100),
//              ),
//            ),
      child: Column(
        children: [
          Icon(
            Icons.clear,
            color: Colors.blueAccent,
            size: size.width * 0.17,
          ),
          Container(
            height: size.width * 0.17,
            width: size.width * 0.5,
//            decoration: BoxDecoration(
//              border: Border.all(
//                color: Colors.blueAccent,
////              color: Colors.deepPurpleAccent,
//                width: size.width * 0.01,
////                border: Border(
////                  bottom: BorderSide(
////                    color: Colors.deepPurple,
////                    width: size.height * 0.005,
////                  ),
//              ),
//              borderRadius: BorderRadius.circular(100),
////            border: Border.all(
////              color: Colors.deepPurple,
////              width: size.height * 0.005,
////            ),
//            ),
            child: Center(
              child: Text(
                "SKIP",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: size.width * 0.09,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
//            ),
//          ],
          ),
        ],
      ),
    ),
  );
}

Widget likeIndicator(size) {
  return Align(
    alignment: Alignment.topLeft,
    child: Transform.rotate(
      angle: 270.0,
      origin: Offset(
        size.width * 0.55,
        -size.height * 0.2,
      ),
      child: Column(
        children: [
          Icon(
            Icons.favorite,
            color: Colors.pinkAccent,
            size: size.width * 0.17,
          ),
          Container(
            height: size.width * 0.17,
            width: size.width * 0.5,
//            decoration: BoxDecoration(
//              border: Border.all(
//                color: Colors.pinkAccent,
//                width: size.width * 0.01,
//              ),
//              borderRadius: BorderRadius.circular(100),
//            ),
            child: Center(
              child: Text(
                "LIKE",
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: size.width * 0.09,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget superLikeIndicator(size) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Transform.rotate(
      angle: 270.0,
      origin: Offset(
        0,
        -size.height * 0.15,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.star,
            color: Colors.orangeAccent,
            size: size.width * 0.17,
          ),
          Container(
            height: size.width * 0.22,
            width: size.width * 0.7,
            margin: EdgeInsets.only(
              bottom: size.height * 0.2,
            ),
//            decoration: BoxDecoration(
//              border: Border.all(
//                color: Colors.orangeAccent,
//                width: size.width * 0.01,
//              ),
//              borderRadius: BorderRadius.circular(100),
//            ),
            child: Center(
              child: Text(
                "SUPER LIKE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: size.width * 0.09,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
