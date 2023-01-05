//著作ok
//font ok

import 'dart:io';
import 'dart:typed_data';
import 'package:Keioboys/Auth/AuthBloc/AuthBloc.dart';
import 'package:Keioboys/Auth/AuthBloc/AuthEvent.dart';
import 'package:Keioboys/Auth/SignUp/PrivacyPolicyPage.dart';
import 'package:Keioboys/Auth/SignUp/TermsOfServicePage.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:Keioboys/Auth/EmailPage.dart';
import 'package:Keioboys/Widgets/SlideRoute.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Keioboys/consts.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpPage extends StatefulWidget {
  final UserFB _userFB;
  final String name;
  final DateTime birthday;
  final String gender;
  final File photoMobile;
  final Uint8List photoWeb;

  SignUpPage({
    Key key,
    @required UserFB userFB,
    @required this.name,
    @required this.birthday,
    @required this.gender,
    this.photoMobile,
    this.photoWeb,
  })  : assert(userFB != null),
        _userFB = userFB,
        super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  UserFB get _userFB => widget._userFB;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword;
  bool _loading;
  var _checkBox = false;

  @override
  void initState() {
    _showPassword = false;
    _loading = false;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          brightness: Brightness.light,
          title: Text(
            'アカウント作成 (5/5)',
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
            child: Container(
              color: white,
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      Center(
                        child: Text(
                          "Keioboys",
                          style: TextStyle(
                            fontFamily: 'DancingScript',
                            fontSize: size.width * 0.2,
                            color: pink,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: size.width * 0.04,
                          right: size.width * 0.04,
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: pink,
                          decoration: InputDecoration(
                            labelText: "メールアドレス",
                            labelStyle: TextStyle(
                              color: pink,
                              fontSize: size.width * 0.05,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: pink,
                                width: size.width * 0.0025,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: pink,
                                width: size.width * 0.0025,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: size.width * 0.04,
                          right: size.width * 0.04,
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: !_showPassword,
                          keyboardType: TextInputType.visiblePassword,
                          cursorColor: pink,
                          decoration: InputDecoration(
                            labelText: "パスワード",
                            labelStyle: TextStyle(
                              color: pink,
                              fontSize: size.width * 0.05,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword
                                    ? FontAwesomeIcons.solidEyeSlash
                                    : FontAwesomeIcons.solidEye,
                                color: pink,
                                size: size.width * 0.05,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: pink,
                                width: size.width * 0.0025,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: pink,
                                width: size.width * 0.0025,
                              ),
                            ),
                          ),
                        ),
                      ),
                      (widget.gender == '男性')
                          ? SizedBox(
                              height: size.height * 0.02,
                            )
                          : SizedBox(
                              height: size.height * 0.015,
                            ),
                      (widget.gender == '男性')
                          ? Padding(
                              padding: EdgeInsets.only(
                                left: size.width * 0.04,
                                right: size.width * 0.04,
                              ),
                              child: Text(
                                '慶應義塾大学(keio.jp・jukuin.keio.ac.jp)または早稲田大学(waseda.jp)のメールアドレスをご登録ください。',
                                style: TextStyle(
                                  color: black87,
                                  fontSize: size.width * 0.038,
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: size.height * 0.015,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: size.width * 0.04,
                          right: size.width * 0.04,
                        ),
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              value: _checkBox,
                              activeColor: white,
                              checkColor: pink,
                              onChanged: (bool value) {
                                setState(() {
                                  _checkBox = value;
                                });
                              },
                            ),
                            GestureDetector(
                              child: Text(
                                '利用規約',
                                style: TextStyle(
                                  color: pink,
                                  fontSize: size.width * 0.038,
                                ),
                              ),
                              onTap: () {
                                pageScroll(TermsOfServicePage(), context);
                              },
                            ),
                            Text(
                              'と',
                              style: TextStyle(
                                color: black87,
                                fontSize: size.width * 0.038,
                              ),
                            ),
                            GestureDetector(
                              child: Text(
                                'プライバシーポリシー',
                                style: TextStyle(
                                  color: pink,
                                  fontSize: size.width * 0.038,
                                ),
                              ),
                              onTap: () {
                                pageScroll(PrivacyPolicyPage(), context);
                              },
                            ),
                            Text(
                              'に同意する',
                              style: TextStyle(
                                color: black87,
                                fontSize: size.width * 0.038,
                              ),
                            ),
                          ],
                        ),
                      ),
                      (widget.gender == '男性')
                          ? SizedBox(
                              height: size.height * 0.015,
                            )
                          : SizedBox(
                              height: size.height * 0.03,
                            ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: size.width * 0.04,
                          right: size.width * 0.04,
                        ),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                if (_loading != true) {
                                  if (_emailController.text.length == 0 &&
                                      _passwordController.text.length == 0) {
                                    Flushbar(
                                      message: "メールアドレスとパスワードを入力してください。",
                                      backgroundColor: pink,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  } else if (_emailController.text.length ==
                                      0) {
                                    Flushbar(
                                      message: "メールアドレスを入力してください。",
                                      backgroundColor: pink,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  } else if (_passwordController.text.length ==
                                      0) {
                                    Flushbar(
                                      message: "パスワードを入力してください。",
                                      backgroundColor: pink,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  } else if (_passwordController.text.length <
                                      6) {
                                    Flushbar(
                                      message: "パスワードを6字以上で入力してください。",
                                      backgroundColor: pink,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  } else if (_checkBox == false) {
                                    Flushbar(
                                      message:
                                          "アカウント作成には、利用規約とプライバシーポリシーへの同意が必要です。",
                                      backgroundColor: pink,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  } else if (widget.gender == '男性' &&
                                      !RegExp(r'[\w\-._]+@(keio.jp|jukuin.keio.ac.jp|akane.waseda.jp|asagi.waseda.jp|fuji.waseda.jp|moegi.waseda.jp|ruri.waseda.jp|suou.waseda.jp|toki.waseda.jp)')
                                          .hasMatch(_emailController.text)) {
                                    Flushbar(
                                      message: "慶應または早稲田の大学のメールアドレスを登録してください。",
                                      backgroundColor: pink,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  } else {
                                    FocusScope.of(context).unfocus();
                                    _loading = true;
                                    String school;
                                    if (RegExp(
                                            r'[\w\-._]+@(keio.jp|jukuin.keio.ac.jp)')
                                        .hasMatch(_emailController.text)) {
                                      school = '慶應義塾大学';
                                    } else if (RegExp(
                                            r'[\w\-._]+@(akane.waseda.jp|asagi.waseda.jp|fuji.waseda.jp|moegi.waseda.jp|ruri.waseda.jp|suou.waseda.jp|toki.waseda.jp)')
                                        .hasMatch(_emailController.text)) {
                                      school = '早稲田大学';
                                    } else {
                                      school = '';
                                    }
//                                    if (web) {
                                    String _result =
                                        await _userFB.signUpAndPreProfile(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      name: widget.name,
                                      birthday: widget.birthday,
                                      gender: widget.gender,
                                      school: school,
                                      photoMobile: widget.photoMobile,
                                      photoWeb: widget.photoWeb,
                                    );
                                    if (_result == 'success') {
                                      BlocProvider.of<AuthBloc>(context).add(
                                        SignUp(
                                          gender: widget.gender,
                                        ),
                                      );
                                      Navigator.of(context).push(
                                        slideRoute(
                                          EmailPage(
                                            userFB: _userFB,
                                            gender: widget.gender,
                                          ),
                                        ),
                                      );
                                    } else if (_result ==
                                        'ERROR_INVALID_EMAIL') {
                                      Flushbar(
                                        message: "メールアドレスが正しくありません。",
                                        backgroundColor: pink,
                                        duration: Duration(seconds: 3),
                                      )..show(context);
                                      setState(() {
                                        _loading = false;
                                      });
                                    } else {
                                      Flushbar(
                                        message: "しばらくしてからもう一度お試しください。",
                                        backgroundColor: pink,
                                        duration: Duration(seconds: 3),
                                      )..show(context);
                                      setState(() {
                                        _loading = false;
                                      });
                                    }
//                                    }
                                  }
                                }
                              },
                              child: Container(
                                width: size.width * 0.8,
                                height: size.height * 0.06,
                                decoration: BoxDecoration(
                                  color: pink,
                                  borderRadius: BorderRadius.circular(
                                    100,
                                  ),
                                  border: Border.all(
                                    color: pink,
                                    width: size.width * 0.0025,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "アカウント作成",
                                    style: TextStyle(
                                      fontSize: size.width * 0.05,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.04,
                            ),
                            (MediaQuery.of(context).viewInsets.bottom > 0)
                                ? SizedBox(
                                    height: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom)
                                : Container(),
                          ],
                        ),
                      )
                    ],
                  ),
                  (_loading)
                      ? Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(pink),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
