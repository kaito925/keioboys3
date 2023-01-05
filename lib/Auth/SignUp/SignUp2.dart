import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:Keioboys/Auth/SignUp/SignUp3.dart';
import 'package:Keioboys/Widgets/SlideRoute.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:Keioboys/consts.dart';

DateTime _birthday2;

class SignUp2 extends StatefulWidget {
  final UserFB _userFB;
  final String name;

  SignUp2({@required UserFB userFB, @required this.name})
      : assert(userFB != null),
        _userFB = userFB;

  @override
  _SignUp2State createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  UserFB get _userFB => widget._userFB;
  var formatter = DateFormat('yyyy/MM/dd');
  DateTime _today = DateTime.now();

  var formatterYear = DateFormat('yyyy');
  var formatterMD = DateFormat('-MM-dd');

  DateTime _birthday = DateTime.now();
  @override
  void initState() {
    if (_birthday2 == null) {
      String year = (int.parse(
                formatterYear.format(_today),
              ) -
              18)
          .toString();
      String md = formatterMD.format(_today);
      _birthday = DateTime.parse(year + md);
      super.initState();
    } else {
      _birthday = _birthday2;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        brightness: Brightness.light,
        title: Text(
          'アカウント作成 (2/5)',
          style: TextStyle(
            color: pink,
          ),
        ),
        iconTheme: IconThemeData(
          color: pink,
        ),
        backgroundColor: white,
//        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.15,
                ),
                Text(
                  '誕生日',
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.1,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.15,
                ),
                Container(
                  height: size.width * 0.23,
                  child: FlatButton(
                    child: Text(
                      formatter.format(_birthday),
                      style: TextStyle(
                        color: black54,
                        fontSize: size.width * 0.13,
                      ),
                    ),
                    onPressed: () {
                      DatePicker.showDatePicker(
                        context,
                        locale: LocaleType.jp,
                        minTime: DateTime.parse("1900-01-01"),
                        maxTime: DateTime.parse(
                          (int.parse(
                                        formatter
                                            .format(_today)
                                            .substring(0, 4),
                                      ) -
                                      18)
                                  .toString() +
                              '-' +
                              formatter.format(_today).substring(5, 7) +
                              '-' +
                              formatter.format(_today).substring(8, 10),
                        ),
                        // うるう年も大丈夫
                        showTitleActions: true,
                        onConfirm: (date) {
                          setState(
                            () {
                              _birthday = date;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.15,
                ),
                GestureDetector(
                  child: Container(
                    width: size.width * 0.7,
                    height: size.width * 0.1,
                    decoration: BoxDecoration(
                      color: pink,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Text(
                        "次へ",
                        style: TextStyle(
                          color: white,
                          fontSize: size.width * 0.06,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    _birthday2 = _birthday;
                    Navigator.of(context).push(
                      slideRoute(
                        SignUp3(
                          userFB: _userFB,
                          name: widget.name,
                          birthday: _birthday,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
