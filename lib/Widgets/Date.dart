import 'package:flutter/material.dart';
import 'package:Keioboys/consts.dart';

Widget dateWidget({
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
  } else if ((date.isAfter(sixDaysBefore))) {
    return (date.minute.toString().length == 1)
        ? Text(
            weekdayFull(date.weekday) +
                date.hour.toString() +
                ":0" +
                date.minute.toString(),
            style: TextStyle(
              color: black87,
              fontSize: size,
//              fontWeight: FontWeight.bold,
            ),
          )
        : Text(
            weekdayFull(date.weekday) +
                date.hour.toString() +
                ":" +
                date.minute.toString(),
            style: TextStyle(
              color: black87,
              fontSize: size,
//              fontWeight: FontWeight.bold,
            ),
          );
  } else if (now.year == date.year) {
    return (date.minute.toString().length == 1)
        ? Text(
            date.month.toString() +
                '月' +
                date.day.toString() +
                '日' +
                weekday(date.weekday) +
                date.hour.toString() +
                ":0" +
                date.minute.toString(),
            style: TextStyle(
              color: black87,
              fontSize: size,
//              fontWeight: FontWeight.bold,
            ),
          )
        : Text(
            date.month.toString() +
                '月' +
                date.day.toString() +
                '日' +
                weekday(date.weekday) +
                date.hour.toString() +
                ":" +
                date.minute.toString(),
            style: TextStyle(
              color: black87,
              fontSize: size,
//              fontWeight: FontWeight.bold,
            ),
          );
  } else {
    return (date.minute.toString().length == 1)
        ? Text(
            date.year.toString() +
                '年' +
                date.month.toString() +
                '月' +
                date.day.toString() +
                '日' +
                weekday(date.weekday) +
                date.hour.toString() +
                ":0" +
                date.minute.toString(),
            style: TextStyle(
              color: black87,
              fontSize: size,
//              fontWeight: FontWeight.bold,
            ),
          )
        : Text(
            date.year.toString() +
                '年' +
                date.month.toString() +
                '月' +
                date.day.toString() +
                '日' +
                weekday(date.weekday) +
                date.hour.toString() +
                ":" +
                date.minute.toString(),
            style: TextStyle(
              color: black87,
              fontSize: size,
//              fontWeight: FontWeight.bold,
            ),
          );
  }
}

String weekday(int weekday) {
  if (weekday == 1) {
    return '(月) ';
  } else if (weekday == 2) {
    return '(火) ';
  } else if (weekday == 3) {
    return '(水) ';
  } else if (weekday == 4) {
    return '(木) ';
  } else if (weekday == 5) {
    return '(金) ';
  } else if (weekday == 6) {
    return '(土) ';
  } else {
    return '(日) ';
  }
}

String weekdayFull(int weekday) {
  if (weekday == 1) {
    return '月曜日 ';
  } else if (weekday == 2) {
    return '火曜日 ';
  } else if (weekday == 3) {
    return '水曜日 ';
  } else if (weekday == 4) {
    return '木曜日 ';
  } else if (weekday == 5) {
    return '金曜日 ';
  } else if (weekday == 6) {
    return '土曜日 ';
  } else {
    return '日曜日 ';
  }
}
