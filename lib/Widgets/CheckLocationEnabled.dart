import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:Keioboys/consts.dart';

void checkLocationEnabled({size, context}) async {
  Location locationService = Location();
  bool isLocationServiceEnabled = await locationService.serviceEnabled();
  if (isLocationServiceEnabled == false) {
    if (ios) {
      showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Container(
                width: size.width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: size.width * 0.02,
                    ),
                    Text(
                      "ご利用のデバイスの位置情報サービスをオンにしてください。",
                      style: TextStyle(
                        color: black87,
                        fontSize: size.width * 0.05,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: pink,
                    ),
                  ),
                  splashColor: lightGrey,
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
        },
      );
    } else {
      await locationService.requestService();
    }
  }
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    if (android) {
      await Geolocator.requestPermission();
    } else {
      showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Container(
                width: size.width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: size.width * 0.02,
                    ),
                    Text(
                      "ご利用のデバイスの設定からStarsが位置情報を利用することを許可してください。",
                      style: TextStyle(
                        color: black87,
                        fontSize: size.width * 0.05,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: pink,
                    ),
                  ),
                  splashColor: lightGrey,
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
        },
      );
    }
  }
}
