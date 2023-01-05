//著作ok
import 'package:flutter/material.dart';
import 'package:Keioboys/consts.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/services.dart';

class PasswordResetPage extends StatefulWidget {
  final UserFB _userFB;

  PasswordResetPage({@required UserFB userFB})
      : assert(userFB != null),
        _userFB = userFB;
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  UserFB get _userFB => widget._userFB;
  final TextEditingController _emailController = TextEditingController();
  String _result;

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
            'パスワードの再設定',
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
              child: Container(
                width: size.width * 0.8,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Text(
                            '登録されたメールアドレスにパスワード再設定用のメールを送ります。',
                            style: TextStyle(
                              color: black87,
                              fontSize: size.width * 0.05,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'メールアドレスを入力してください。',
                              style: TextStyle(
                                color: black87,
                                fontSize: size.width * 0.05,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.12,
                    ),
                    Container(
                      height: size.width * 0.23,
                      width: size.width * 0.8,
                      child: TextField(
                        controller: _emailController,
                        cursorColor: pink,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: black87,
                          fontSize: size.width * 0.045,
                        ),
                        decoration: InputDecoration(
                          hintText: 'メールアドレス',
                          hintStyle: TextStyle(
                            color: black87,
                            fontSize: size.width * 0.045,
                          ),
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
                        maxLength: null,
                        maxLengthEnforcement: MaxLengthEnforcement.none,
                        autofocus: true,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.12,
                    ),
                    GestureDetector(
                      child: Container(
                        width: size.width * 0.7,
                        height: size.width * 0.12,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: pink,
                            width: size.width * 0.005,
                          ),
                          color: white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Text(
                            "送信",
                            style: TextStyle(
                              color: pink,
                              fontSize: size.width * 0.06,
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (_emailController.text
                                .replaceAll(RegExp(r"\s"), "")
                                .replaceAll(RegExp(r"　"), "") !=
                            '') {
                          Navigator.of(context).pop();
                          _result = await _userFB
                              .sendPasswordResetEmail(_emailController.text);

                          if (_result == 'success') {
                            Navigator.pop(context);
                            Flushbar(
                              message: "メールを送信しました。",
                              backgroundColor: pink,
                              duration: Duration(seconds: 3),
                            )..show(context);
                          } else if (_result == 'ERROR_INVALID_EMAIL') {
                            Flushbar(
                              message: "無効なメールアドレスです",
                              backgroundColor: pink,
                              duration: Duration(seconds: 3),
                            )..show(context);
                          } else if (_result == 'ERROR_USER_NOT_FOUND') {
                            Flushbar(
                              message: "メールアドレスが登録されていません",
                              backgroundColor: pink,
                              duration: Duration(seconds: 3),
                            )..show(context);
                          } else if (_result == 'ERROR_TOO_MANY_REQUESTS') {
                            Flushbar(
                              message: "しばらく時間をあけてもう一度お試しください",
                              backgroundColor: pink,
                              duration: Duration(seconds: 3),
                            )..show(context);
                          } else {
                            Flushbar(
                              message: "メール送信に失敗しました",
                              backgroundColor: pink,
                              duration: Duration(seconds: 3),
                            )..show(context);
                          }
                        } else {
                          Flushbar(
                            message: "メールアドレスを入力してください。",
                            backgroundColor: pink,
                            duration: Duration(seconds: 3),
                          )..show(context);
                        }
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    FlatButton(
                      child: Text('お問い合わせ',
                          style: TextStyle(
                            color: pink,
                          )),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return AlertDialog(
                                title: Text("お問い合わせ"),
                                content: Container(
                                  width: size.width * 0.9,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                          'お手数ですがご登録のメールアドレスから下記のメールアドレスまでお問い合わせください。'),
                                      SizedBox(
                                        height: size.height * 0.05,
                                      ),
                                      Text('info@keioboys.com'),
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
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              );
                            });
                          },
                        );
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
