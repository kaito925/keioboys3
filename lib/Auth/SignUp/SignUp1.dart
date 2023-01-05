import 'package:Keioboys/Widgets/SlideRoute.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:Keioboys/consts.dart';
import 'package:Keioboys/Auth/SignUp/SignUp2.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:flutter/services.dart';

class SignUp1 extends StatefulWidget {
  final UserFB _userFB;

  SignUp1({@required UserFB userFB})
      : assert(userFB != null),
        _userFB = userFB;
  @override
  _SignUp1State createState() => _SignUp1State();
}

class _SignUp1State extends State<SignUp1> {
  UserFB get _userFB => widget._userFB;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _nameController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            brightness: Brightness.light,
            title: Text(
              'アカウント作成 (1/5)',
              style: TextStyle(
                color: pink,
              ),
            ),
            iconTheme: IconThemeData(
              color: pink,
            ),
            backgroundColor: white,
//          elevation: 0,
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
                      'ニックネーム',
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
                      width: size.width * 0.8,
                      child: TextField(
                        controller: _nameController,
                        cursorColor: pink,
                        style: TextStyle(
                          color: black87,
                          fontSize: size.width * 0.07,
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: black87,
                              width: size.width * 0.0025,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: black87,
                              width: size.width * 0.0025,
                            ),
                          ),
                        ),
                        minLines: 1,
                        maxLines: 1,
                        maxLength: 10,
                        maxLengthEnforcement: MaxLengthEnforcement.none,
                        autofocus: true,
                        onEditingComplete: () async {
                          if (web) {
                            FocusScope.of(context).unfocus();
                          }
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
//                        border: Border.all(
//                          color: pink,
//                          width: size.width * 0.005,
//                        ),
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
                        if (_nameController.text.length > 8) {
                          Flushbar(
                            message: "ニックネームは8文字以内で入力してください。",
                            backgroundColor: pink,
                            duration: Duration(seconds: 3),
                          )..show(context);
                        } else if (_nameController.text.length == 0) {
                          Flushbar(
                            message: "ニックネームを入力してください。",
                            backgroundColor: pink,
                            duration: Duration(seconds: 3),
                          )..show(context);
                        } else {
                          Navigator.of(context).push(
                            slideRoute(
                              SignUp2(
                                  userFB: _userFB, name: _nameController.text),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
