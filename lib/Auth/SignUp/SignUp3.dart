import 'package:Keioboys/Auth/SignUp/SignUp4.dart';
import 'package:Keioboys/Widgets/SlideRoute.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:Keioboys/consts.dart';

String gender;

class SignUp3 extends StatefulWidget {
  final UserFB _userFB;
  final String name;
  final DateTime birthday;

  SignUp3({
    @required UserFB userFB,
    @required this.name,
    @required this.birthday,
  })  : assert(userFB != null),
        _userFB = userFB;

  @override
  _SignUp3State createState() => _SignUp3State();
}

class _SignUp3State extends State<SignUp3> {
  UserFB get _userFB => widget._userFB;

  @override
  void initState() {
    gender = '女性';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        brightness: Brightness.light,
        title: Text(
          'アカウント作成 (3/5)',
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
                  "性別",
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.1,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    genderWidget(
                      icon: MdiIcons.humanFemale,
                      text: "女性",
                      color: pink,
                      gender: gender,
                      onTap: () {
                        setState(
                          () {
                            gender = "女性";
                          },
                        );
                      },
                    ),
                    genderWidget(
                      icon: MdiIcons.humanMale,
                      text: "男性",
                      color: black87,
                      gender: gender,
                      onTap: () {
                        setState(
                          () {
                            gender = "男性";
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.12,
                ),
                GestureDetector(
                  onTap: () {
                    print('性別: $gender');
                    if (gender != null) {
                      Navigator.of(context).push(
                        slideRoute(
                          SignUp4(
                            userFB: _userFB,
                            name: widget.name,
                            birthday: widget.birthday,
                            gender: gender,
                          ),
                        ),
                      );
                    } else {
                      Flushbar(
                        message: "性別を選んでください。",
                        backgroundColor: pink,
                        duration: Duration(seconds: 3),
                      )..show(context);
                    }
                  },
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget genderWidget({
    icon,
    text,
    color,
    gender,
    onTap,
  }) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: size.width * 0.25,
              color: gender == (text) ? color : lightGrey,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Text(
              text,
              style: TextStyle(
                color: (gender == text) ? color : lightGrey,
                fontSize: size.width * 0.05,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
