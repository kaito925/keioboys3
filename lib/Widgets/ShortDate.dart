import 'package:flutter/material.dart';
import 'package:Keioboys/consts.dart';

Widget shortDateWidget({
  DateTime date,
  double size,
}) {
  DateTime now = DateTime.now();
  DateTime yesterday = DateTime.now().add(Duration(days: -1));
  DateTime sixDaysBefore = DateTime.now().add(Duration(days: -6));

  if (now.year == date.year && now.month == date.month && now.day == date.day) {
    return (date.minute.toString().length == 1)
        ? Text(
            '今日 ' + date.hour.toString() + ":0" + date.minute.toString(),
            style: TextStyle(
              color: black87,
              fontSize: size,
//              fontWeight: FontWeight.bold,
            ),
          )
        : Text(
            '今日 ' + date.hour.toString() + ":" + date.minute.toString(),
            style: TextStyle(
              color: black87,
              fontSize: size,
//              fontWeight: FontWeight.bold,
            ),
          );
  } else if (yesterday.year == date.year &&
      yesterday.month == date.month &&
      yesterday.day == date.day) {
    return (date.minute.toString().length == 1)
        ? Text(
            '昨日 ' + date.hour.toString() + ":0" + date.minute.toString(),
            style: TextStyle(
              color: black87,
              fontSize: size,
//              fontWeight: FontWeight.bold,
            ),
          )
        : Text(
            '昨日 ' + date.hour.toString() + ":" + date.minute.toString(),
            style: TextStyle(
              color: black87,
              fontSize: size,
//              fontWeight: FontWeight.bold,
            ),
          );
  } else if (now.year == date.year) {
    return Text(
      date.month.toString() + '/' + date.day.toString(),
      style: TextStyle(
        color: black87,
        fontSize: size,
//              fontWeight: FontWeight.bold,
      ),
    );
  } else {
    return Text(
      date.year.toString() +
          '/' +
          date.month.toString() +
          '/' +
          date.day.toString(),
      style: TextStyle(
        color: black87,
        fontSize: size,
//              fontWeight: FontWeight.bold,
      ),
    );
  }
}
