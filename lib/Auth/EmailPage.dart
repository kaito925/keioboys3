//著作ok
import 'dart:async';

import 'package:Keioboys/Auth/AuthBloc/AuthBloc.dart';
import 'package:Keioboys/Auth/AuthBloc/AuthEvent.dart';
import 'package:Keioboys/Auth/Login/LoginPage.dart';
import 'package:Keioboys/Auth/NewNotificationPage.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:Keioboys/Widgets/CheckLocationEnabled.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:Keioboys/consts.dart';
import 'package:Keioboys/Widgets/HomeTab.dart';

class EmailPage extends StatefulWidget {
  final UserFB _userFB;
  final String _gender;
  final bool _fromMain;

  EmailPage({
    @required UserFB userFB,
    String gender,
    bool fromMain,
  })  : assert(userFB != null),
        _userFB = userFB,
        _gender = gender,
        _fromMain = fromMain;

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  UserFB get _userFB => widget._userFB;
  TextEditingController _passwordControllerForDeleteAccountEmailPage;
  TextEditingController _passwordControllerForEmailChangeEmailPage;
  TextEditingController _newEmailControllerEmailPage;
  TextEditingController _newEmailConfirmControllerEmailPage;

  bool _showPassword;
  bool _showPasswordForEmailChange;

  Timer _timer;

  String _uid;
  UserData _currentUser;
  bool loading1;
  int count;

  void getUidAndCurrentUser() async {
    _uid = await _userFB.getCurrentUserId();
    _currentUser = await _userFB.getCurrentUser(_uid);
  }

  @override
  void initState() {
    loading1 = false;
    _showPassword = false;
    _showPasswordForEmailChange = false;
//    BlocProvider.of<AuthBloc>(context).dispatch(
//      EmailNotVerified(),
//    );
    getUidAndCurrentUser();
    count = 1;
    super.initState();
  }

  @override
  void dispose() {
//    if (_passwordControllerForDeleteAccountEmailPage != null) {
//      _passwordControllerForDeleteAccountEmailPage.dispose();
//    }
    if (_passwordControllerForEmailChangeEmailPage != null) {
      _passwordControllerForEmailChangeEmailPage.dispose();
    }
    if (_newEmailControllerEmailPage != null) {
      _newEmailControllerEmailPage.dispose();
    }
    if (_newEmailConfirmControllerEmailPage != null) {
      _newEmailConfirmControllerEmailPage.dispose();
    }

//    if (_timer != null) {
//      _timer.cancel();
//    }
    super.dispose();
  }

//  void _reSendTimer() {
//    errorHappen = false;
//    setState(() {
//      print('再送信エラー: $errorHappen');
//    });
//  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
//    checkLocationEnabled(
//      size: size,
//      context: context,
//    );
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            brightness: Brightness.light,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'メールアドレス確認',
                  style: TextStyle(
                    color: pink,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: pink,
//                  size: size.height * 0.035,
                  ),
                  onPressed: () {
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
                                  FlatButton(
                                    child: Container(
                                      height: size.height * 0.05,
                                      width: size.width * 0.9,
                                      child: Center(
                                        child: Text(
                                          '確認メール再送信',
                                          style: TextStyle(
                                            color: black87,
                                            fontSize: size.width * 0.05,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      String _result =
                                          await _userFB.sendEmailCode();
                                      if (_result == 'success') {
                                      } else {
                                        Flushbar(
                                          message: "しばらくしてからもう一度お試しください。",
                                          backgroundColor: pink,
                                          duration: Duration(seconds: 3),
                                        )..show(context);
                                      }
                                    },
                                  ),
                                  Divider(
                                    color: black87,
                                  ),
                                  FlatButton(
                                    child: Container(
                                      height: size.height * 0.05,
                                      width: size.width * 0.9,
                                      child: Center(
                                        child: Text(
                                          'メールアドレス変更',
                                          style: TextStyle(
                                            color: black87,
                                            fontSize: size.width * 0.05,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          _newEmailControllerEmailPage =
                                              TextEditingController();
                                          _newEmailConfirmControllerEmailPage =
                                              TextEditingController();
                                          _passwordControllerForEmailChangeEmailPage =
                                              TextEditingController();
                                          bool loadingEmailChange = false;
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return Center(
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: GestureDetector(
                                                    onTap: () =>
                                                        FocusScope.of(context)
                                                            .unfocus(),
                                                    child: AlertDialog(
                                                      title: Text("メールアドレスの変更"),
                                                      content: Container(
                                                        width: size.width * 0.9,
                                                        height:
                                                            size.height * 0.6,
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "メールアドレスを変更するとログアウトします。新しいメールアドレスでもう一度ログインしてください。",
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        black87,
                                                                    fontSize:
                                                                        size.width *
                                                                            0.045,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "現在のメールアドレス",
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        black87,
                                                                    fontSize:
                                                                        size.width *
                                                                            0.05,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  _currentUser
                                                                      .email,
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        black87,
                                                                    fontSize:
                                                                        size.width *
                                                                            0.05,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      size.height *
                                                                          0.05,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      _newEmailControllerEmailPage,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .emailAddress,
                                                                  cursorColor:
                                                                      pink,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        "新しいメールアドレス",
                                                                    labelStyle:
                                                                        TextStyle(
                                                                      color:
                                                                          black87,
                                                                      fontSize:
                                                                          size.width *
                                                                              0.05,
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color:
                                                                            black87,
                                                                        width: size.width *
                                                                            0.002,
                                                                      ),
                                                                    ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color:
                                                                            black87,
                                                                        width: size.width *
                                                                            0.002,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      size.height *
                                                                          0.02,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      _newEmailConfirmControllerEmailPage,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .emailAddress,
                                                                  cursorColor:
                                                                      pink,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        "新しいメールアドレス (確認)",
                                                                    labelStyle:
                                                                        TextStyle(
                                                                      color:
                                                                          black87,
                                                                      fontSize:
                                                                          size.width *
                                                                              0.04,
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color:
                                                                            black87,
                                                                        width: size.width *
                                                                            0.002,
                                                                      ),
                                                                    ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color:
                                                                            black87,
                                                                        width: size.width *
                                                                            0.002,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      size.height *
                                                                          0.02,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      _passwordControllerForEmailChangeEmailPage,
                                                                  obscureText:
                                                                      !_showPasswordForEmailChange,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .visiblePassword,
                                                                  cursorColor:
                                                                      pink,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        "パスワード",
                                                                    labelStyle:
                                                                        TextStyle(
                                                                      color:
                                                                          black87,
                                                                      fontSize:
                                                                          size.width *
                                                                              0.05,
                                                                    ),
                                                                    suffixIcon:
                                                                        IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        _showPasswordForEmailChange
                                                                            ? FontAwesomeIcons.solidEyeSlash
                                                                            : FontAwesomeIcons.solidEye,
                                                                        color:
                                                                            black54,
                                                                        size: size.width *
                                                                            0.05,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                          () {
                                                                            _showPasswordForEmailChange =
                                                                                !_showPasswordForEmailChange;
                                                                          },
                                                                        );
                                                                      },
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color:
                                                                            black87,
                                                                        width: size.width *
                                                                            0.002,
                                                                      ),
                                                                    ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color:
                                                                            black87,
                                                                        width: size.width *
                                                                            0.002,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            (loadingEmailChange)
                                                                ? Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      valueColor:
                                                                          AlwaysStoppedAnimation(
                                                                        pink,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text(
                                                            "キャンセル",
                                                            style: TextStyle(
                                                              color: black87,
                                                            ),
                                                          ),
                                                          splashColor:
                                                              lightGrey,
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                        ),
                                                        FlatButton(
                                                          child: Text(
                                                            "変更",
                                                            style: TextStyle(
                                                              color: pink,
                                                            ),
                                                          ),
                                                          splashColor:
                                                              lightGrey,
                                                          onPressed: () async {
                                                            if (loadingEmailChange !=
                                                                true) {
                                                              if (_newEmailControllerEmailPage
                                                                      .text ==
                                                                  _newEmailConfirmControllerEmailPage
                                                                      .text) {
                                                                if (widget._gender ==
                                                                        '男性' &&
                                                                    !RegExp(r'[\w\-._]+@(keio.jp|jukuin.keio.ac.jp|akane.waseda.jp|asagi.waseda.jp|fuji.waseda.jp|moegi.waseda.jp|ruri.waseda.jp|suou.waseda.jp|toki.waseda.jp)')
                                                                        .hasMatch(
                                                                            _newEmailControllerEmailPage.text)) {
                                                                  Flushbar(
                                                                    message:
                                                                        "慶應または早稲田の大学のメールアドレスを登録してください。",
                                                                    backgroundColor:
                                                                        pink,
                                                                    duration: Duration(
                                                                        seconds:
                                                                            3),
                                                                  )..show(
                                                                      context);
                                                                } else {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                  loadingEmailChange =
                                                                      true;
                                                                  String _result = await _userFB.changeEmail(
                                                                      password:
                                                                          _passwordControllerForEmailChangeEmailPage
                                                                              .text,
                                                                      newEmail:
                                                                          _newEmailControllerEmailPage
                                                                              .text);
                                                                  if (_result ==
                                                                      'success') {
                                                                    try {
                                                                      Navigator.pop(
                                                                          context);
                                                                      BlocProvider.of<AuthBloc>(
                                                                              context)
                                                                          .add(
                                                                        LogOut(
                                                                          currentUserId:
                                                                              _currentUser.uid,
                                                                        ),
                                                                      );
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pushAndRemoveUntil(
                                                                        MaterialPageRoute(
                                                                          builder:
                                                                              (context) {
                                                                            return LoginPage(
                                                                              userFB: _userFB,
                                                                            );
                                                                          },
                                                                        ),
                                                                        (_) =>
                                                                            false,
                                                                      );
                                                                      Flushbar(
                                                                        message:
                                                                            "メールアドレスを変更しました。",
                                                                        backgroundColor:
                                                                            pink,
                                                                        duration:
                                                                            Duration(seconds: 3),
                                                                      )..show(
                                                                          context);
                                                                    } catch (error) {
                                                                      print(
                                                                          'error: $error');
                                                                      Flushbar(
                                                                        message:
                                                                            "しばらくしてからもう一度お試しください。",
                                                                        backgroundColor:
                                                                            pink,
                                                                        duration:
                                                                            Duration(seconds: 3),
                                                                      )..show(
                                                                          context);
                                                                      setState(
                                                                        () {
                                                                          loadingEmailChange =
                                                                              false;
                                                                        },
                                                                      );
                                                                    }
                                                                  } else if (_result ==
                                                                      'ERROR_WRONG_PASSWORD') {
                                                                    Flushbar(
                                                                      message:
                                                                          "パスワードが間違っています。",
                                                                      backgroundColor:
                                                                          pink,
                                                                      duration: Duration(
                                                                          seconds:
                                                                              3),
                                                                    )..show(
                                                                        context);
                                                                    setState(
                                                                      () {
                                                                        loadingEmailChange =
                                                                            false;
                                                                      },
                                                                    );
                                                                  } else {
                                                                    Flushbar(
                                                                      message:
                                                                          "しばらくしてからもう一度お試しください。",
                                                                      backgroundColor:
                                                                          pink,
                                                                      duration: Duration(
                                                                          seconds:
                                                                              3),
                                                                    )..show(
                                                                        context);
                                                                    setState(
                                                                      () {
                                                                        loadingEmailChange =
                                                                            false;
                                                                      },
                                                                    );
                                                                  }
                                                                }
                                                              } else {
                                                                setState(
                                                                  () {
                                                                    Flushbar(
                                                                      message:
                                                                          "メールアドレスが一致しません。",
                                                                      backgroundColor:
                                                                          pink,
                                                                      duration: Duration(
                                                                          seconds:
                                                                              3),
                                                                    )..show(
                                                                        context);
                                                                  },
                                                                );
                                                              }
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  Divider(
                                    color: black87,
                                  ),
                                  FlatButton(
                                    child: Container(
                                      height: size.height * 0.05,
                                      width: size.width * 0.9,
                                      child: Center(
                                        child: Text(
                                          'お問い合わせ',
                                          style: TextStyle(
                                            color: black87,
                                            fontSize: size.width * 0.05,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text(
                                                        'お手数ですがご登録のメールアドレスから下記のメールアドレスまでお問い合わせください。'),
                                                    SizedBox(
                                                      height:
                                                          size.height * 0.03,
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
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                              ],
                                            );
                                          });
                                        },
                                      );
                                    },
                                  ),
                                  Divider(
                                    color: black87,
                                  ),
                                  FlatButton(
                                    child: Container(
                                      height: size.height * 0.05,
                                      width: size.width * 0.9,
                                      child: Center(
                                        child: Text(
                                          'アカウント削除',
                                          style: TextStyle(
                                            color: black87,
                                            fontSize: size.width * 0.05,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          return StatefulBuilder(
                                              builder: (context, setState) {
                                            return AlertDialog(
                                              title: Text("よろしいですか?"),
                                              content: Container(
                                                width: size.width * 0.9,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text(
                                                      "アカウントを削除すると二度とこのアカウントにはログインできなくなります。",
                                                      style: TextStyle(
                                                        color: black87,
                                                        fontSize:
                                                            size.width * 0.05,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text(
                                                    "いいえ",
                                                    style: TextStyle(
                                                      color: black87,
                                                    ),
                                                  ),
                                                  splashColor: lightGrey,
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                                FlatButton(
                                                  child: Text(
                                                    "はい",
                                                    style: TextStyle(
                                                      color: pink,
                                                    ),
                                                  ),
                                                  splashColor: lightGrey,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        _passwordControllerForDeleteAccountEmailPage =
                                                            TextEditingController();
                                                        bool loading = false;
                                                        return StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                            return Center(
                                                              child:
                                                                  SingleChildScrollView(
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () =>
                                                                      FocusScope.of(
                                                                              context)
                                                                          .unfocus(),
                                                                  child:
                                                                      AlertDialog(
                                                                    title: Text(
                                                                        "アカウントの削除"),
                                                                    content:
                                                                        Container(
                                                                      width: size
                                                                              .width *
                                                                          0.9,
                                                                      height: size
                                                                              .height *
                                                                          0.14,
                                                                      child:
                                                                          Stack(
                                                                        children: <
                                                                            Widget>[
                                                                          Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: <Widget>[
                                                                              SizedBox(
                                                                                height: size.width * 0.05,
                                                                              ),
//                                                            Text(
//                                                              "パスワードを入力してください。",
//                                                              style: TextStyle(
//                                                                  color:
//                                                                      black87),
//                                                            ),
//                                                            SizedBox(
//                                                              height:
//                                                                  size.height *
//                                                                      0.04,
//                                                            ),
                                                                              TextFormField(
                                                                                controller: _passwordControllerForDeleteAccountEmailPage,
                                                                                obscureText: !_showPassword,
                                                                                keyboardType: TextInputType.visiblePassword,
                                                                                cursorColor: pink,
                                                                                decoration: InputDecoration(
                                                                                  labelText: "パスワード",
                                                                                  labelStyle: TextStyle(
                                                                                    color: black87,
                                                                                    fontSize: size.width * 0.05,
                                                                                  ),
                                                                                  suffixIcon: IconButton(
                                                                                    icon: Icon(
                                                                                      (_showPassword) ? FontAwesomeIcons.solidEyeSlash : FontAwesomeIcons.solidEye,
                                                                                      color: black54,
                                                                                      size: size.width * 0.05,
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      setState(
                                                                                        () {
                                                                                          _showPassword = !_showPassword;
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: black87,
                                                                                      width: size.width * 0.002,
                                                                                    ),
                                                                                  ),
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: black87,
                                                                                      width: size.width * 0.002,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          (loading == true)
                                                                              ? Center(
                                                                                  heightFactor: size.height * 0.01,
                                                                                  child: CircularProgressIndicator(
                                                                                    valueColor: AlwaysStoppedAnimation(pink),
                                                                                  ),
                                                                                )
                                                                              : Container(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    actions: <
                                                                        Widget>[
                                                                      FlatButton(
                                                                        child:
                                                                            Text(
                                                                          "キャンセル",
                                                                          style:
                                                                              TextStyle(color: black87),
                                                                        ),
                                                                        splashColor:
                                                                            lightGrey,
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                      FlatButton(
                                                                        child:
                                                                            Text(
                                                                          "削除",
                                                                          style:
                                                                              TextStyle(color: pink),
                                                                        ),
                                                                        splashColor:
                                                                            lightGrey,
                                                                        onPressed:
                                                                            () async {
                                                                          if (loading !=
                                                                              true) {
                                                                            if (_passwordControllerForDeleteAccountEmailPage.text.length ==
                                                                                0) {
                                                                              Flushbar(
                                                                                message: "パスワードを入力してください。",
                                                                                backgroundColor: pink,
                                                                                duration: Duration(seconds: 3),
                                                                              )..show(context);
                                                                            } else if (_passwordControllerForDeleteAccountEmailPage.text.length <
                                                                                6) {
                                                                              Flushbar(
                                                                                message: "パスワードを6字以上で入力してください。",
                                                                                backgroundColor: pink,
                                                                                duration: Duration(seconds: 3),
                                                                              )..show(context);
                                                                            } else {
                                                                              FocusScope.of(context).unfocus();
                                                                              setState(() {
                                                                                loading = true;
                                                                              });
                                                                              String _resultReAuth = await _userFB.reAuthenticate(_passwordControllerForDeleteAccountEmailPage.text);
                                                                              if (_resultReAuth == 'success') {
                                                                                String _result = await _userFB.deleteAccount(_passwordControllerForDeleteAccountEmailPage.text);
                                                                                if (_result == 'success') {
                                                                                  _passwordControllerForDeleteAccountEmailPage.text = '';
                                                                                  _passwordControllerForDeleteAccountEmailPage.clear();
                                                                                  BlocProvider.of<AuthBloc>(context).add(
                                                                                    Deleted(),
                                                                                  );
                                                                                  Timer(Duration(milliseconds: 300), () {
                                                                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                                                                      builder: (context) {
                                                                                        return LoginPage(userFB: _userFB);
                                                                                      },
                                                                                    ), (_) => false);
                                                                                    Flushbar(
                                                                                      message: "アカウントを削除しました。",
                                                                                      backgroundColor: pink,
                                                                                      duration: Duration(seconds: 3),
                                                                                    )..show(context);
                                                                                  });
                                                                                } else {
                                                                                  Flushbar(
                                                                                    message: "しばらくしてからもう一度お試しください。",
                                                                                    backgroundColor: pink,
                                                                                    duration: Duration(seconds: 3),
                                                                                  )..show(context);
                                                                                  setState(() {
                                                                                    loading = false;
                                                                                  });
                                                                                }
                                                                              } else if (_resultReAuth == 'wrong-password') {
                                                                                Flushbar(
                                                                                  message: "パスワードが間違っています。",
                                                                                  backgroundColor: pink,
                                                                                  duration: Duration(seconds: 3),
                                                                                )..show(context);
                                                                                setState(() {
                                                                                  loading = false;
                                                                                });
                                                                              } else {
                                                                                Flushbar(
                                                                                  message: "しばらくしてからもう一度お試しください。",
                                                                                  backgroundColor: pink,
                                                                                  duration: Duration(seconds: 3),
                                                                                )..show(context);
                                                                                setState(() {
                                                                                  loading = false;
                                                                                });
                                                                              }
                                                                            }
                                                                          }
                                                                        },
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                )
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
                          );
                        });
                      },
                    );
                  },
                ),
              ],
            ),
            iconTheme: IconThemeData(
              color: pink,
            ),
            backgroundColor: white,
//            elevation: 0,
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SafeArea(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: size.width * 0.02,
                              right: size.width * 0.02,
                            ),
                            child: Text(
                              'ご入力のメールアドレス宛に確認のメールを送信しました。メール中のURLをクリックしてから次へお進みください。',
                              style: TextStyle(
                                color: black87,
                                fontSize: size.width * 0.05,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.55,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (count == 1) {
                                count = 2;
//                                var userReload =
//                                    FirebaseAuth.instance.currentUser..reload();
                              } else if (loading1 != true &&
                                  (count == 2 || count == 3)) {
                                count = count + 1;
                                setState(() {
                                  loading1 = true;
                                });
//                              var userReload = FirebaseAuth.instance.currentUser
//                                ..reload();
//                              dynamic newUser =
//                                  FirebaseAuth.instance.currentUser;
//                              bool isEmailVerified = newUser.isEmailVerified;
//                              print('user.isEmailVerified: $isEmailVerified');
                                final isVerified =
                                    await _userFB.isEmailVerified();
                                if (isVerified == true) {
//                                Timer(
//                                    Duration(milliseconds: 500),
//                                    () =>
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                      return NewNotificationPage(
                                        currentUser: _currentUser,
                                        appOpenUpdate:
                                            (widget._fromMain == true)
                                                ? false
                                                : true,
                                      );
                                    }),
                                  );
                                  BlocProvider.of<AuthBloc>(context).add(
                                    EmailVerified(currentUser: _currentUser),
                                  );
//                                );
                                  setState(() {
                                    loading1 = false;
                                  });
                                } else {
                                  setState(() {
                                    loading1 = false;
                                  });
                                  Timer(Duration(milliseconds: 100), () async {
                                    if (loading1 == false) {
                                      if (count == 4) {
                                        Flushbar(
                                          message: "メールを確認してください。",
                                          backgroundColor: pink,
                                          duration: Duration(seconds: 3),
                                        )..show(context);
                                      }
                                      count = 3;
                                    }
                                  });
                                }
                              } else {}
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
                  (loading1 == true)
                      ? Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Center(
                              heightFactor: size.height * 0.01,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(pink),
                              ),
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

  Future<bool> _willPopCallback() async {
    return false;
  }
}
