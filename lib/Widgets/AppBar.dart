import 'package:flutter/material.dart';
import 'package:Keioboys/consts.dart';

Widget appBar() {
  return AppBar(
    toolbarHeight: 80,
    brightness: Brightness.light,
    backgroundColor: white,
    leading: Container(),
    flexibleSpace: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TabBar(
          indicatorColor: pink,
          tabs: <Widget>[
            Tab(
                icon: Icon(
              Icons.person,
              size: 33,
              color: pink,
            )),
            Tab(
                icon: Icon(
              Icons.search,
              size: 33,
              color: pink,
            )),
            Tab(
                icon: Icon(
              Icons.message,
              size: 33,
              color: pink,
            )),
          ],
        )
      ],
    ),
  );
}
