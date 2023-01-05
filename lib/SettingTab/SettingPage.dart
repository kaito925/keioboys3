//著作ok
//fontsize ok
//dispose ok

import 'dart:async';

import 'package:Keioboys/Auth/AuthBloc/AuthBloc.dart';
import 'package:Keioboys/Auth/AuthBloc/AuthEvent.dart';
import 'package:Keioboys/Auth/AuthBloc/AuthState.dart';
import 'package:Keioboys/Auth/Login/LoginPage.dart';
import 'package:Keioboys/MessageTab/AgeVerificationPage.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:Keioboys/Auth/NewNotificationPage.dart';
import 'package:Keioboys/FB/MessageFB.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Keioboys/Widgets/HomeTab.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import '../Auth/SignUp/PrivacyPolicyPage.dart';
import '../Auth/SignUp/TermsOfServicePage.dart';
import '../Widgets/SlideRoute.dart';
import '../consts.dart';

class SettingPage extends StatefulWidget {
  final UserFB _userFB;
  final UserData _currentUser;

  SettingPage({
    Key key,
    @required UserFB userFB,
    UserData currentUser,
  })  : assert(userFB != null),
        _userFB = userFB,
        _currentUser = currentUser,
        super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  UserFB get _userFB => widget._userFB;
  final MessageFB _messageFB = MessageFB();
  String interestedGender;

  TextEditingController _passwordControllerForDeleteAccount;
  TextEditingController _passwordControllerForEmailChange;
  TextEditingController _newEmailController;
  TextEditingController _newEmailConfirmController;
  TextEditingController _newPasswordController;
  TextEditingController _passwordControllerForPasswordChange;

  bool _showPassword;
  bool _showPasswordForEmailChange;
  bool _showPasswordForPasswordChange;
  bool _showNewPassword;
  bool _citySwitchValue;
  bool _visibleSwitchValue;

  @override
  void initState() {
    _showPassword = false;
    _showPasswordForEmailChange = false;
    _showPasswordForPasswordChange = false;
    _showNewPassword = false;
    if (widget._currentUser.city == 'hide') {
      _citySwitchValue = false;
    } else {
      _citySwitchValue = true;
    }
    _visibleSwitchValue = widget._currentUser.visible;
    super.initState();
  }

  @override
  void dispose() {
    if (_passwordControllerForDeleteAccount != null) {
      _passwordControllerForDeleteAccount.dispose();
    }
    if (_passwordControllerForEmailChange != null) {
      _passwordControllerForEmailChange.dispose();
    }
    if (_newEmailController != null) {
      _newEmailController.dispose();
    }
    if (_newEmailConfirmController != null) {
      _newEmailConfirmController.dispose();
    }
    if (_newPasswordController != null) {
      _newPasswordController.dispose();
    }
    if (_passwordControllerForPasswordChange != null) {
      _passwordControllerForPasswordChange.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        brightness: Brightness.light,
        title: Text(
          '設定',
          style: TextStyle(
            color: pink,
          ),
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
          child: Center(
            child: Container(
              width: size.width * 0.8,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  (widget._currentUser.ageVerification != true)
                      ? Divider(
                          height: size.height * 0.01,
                          color: black87,
                        )
                      : Container(),
                  (widget._currentUser.ageVerification != true)
                      ? FlatButton(
                          child: Container(
                            height: size.height * 0.05,
                            width: size.width * 0.8,
                            child: Center(
                              child: Text(
                                '年齢確認',
                                style: TextStyle(
                                  color: pink,
                                  fontSize: size.width * 0.05,
                                ),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              slideRoute(
                                AgeVerificationPage(
                                  userFB: _userFB,
                                  currentUser: widget._currentUser,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(),
                  Divider(
                    height: size.height * 0.01,
                    color: black87,
                  ),
                  FlatButton(
                    child: Container(
                      height: size.height * 0.05,
                      width: size.width * 0.8,
                      child: Center(
                        child: Text(
                          'お知らせ',
                          style: TextStyle(
                            color: black87,
                            fontSize: size.width * 0.05,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        slideRoute(
                          NewNotificationPage(
                            currentUser: widget._currentUser,
                            fromSetting: true,
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(
                    height: size.height * 0.01,
                    color: black87,
                  ),
                  FlatButton(
                    child: Container(
                      height: size.height * 0.05,
                      width: size.width * 0.8,
                      child: Center(
                        child: Text(
                          'マッチしたい人の性別',
                          style: TextStyle(
                            color: black87,
                            fontSize: size.width * 0.05,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: Text("マッチしたい人の性別"),
                                content: Container(
                                  width: size.width * 0.9,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
//                                    SizedBox(
//                                      height: size.height * 0.02,
//                                    ),
                                      Divider(
                                        height: size.height * 0.01,
                                        color: black87,
                                      ),
                                      FlatButton(
                                        child: Container(
                                          height: size.height * 0.05,
                                          width: size.width * 0.8,
                                          child: Center(
                                            child: Text(
                                              "女性",
                                              style: TextStyle(
                                                color: (widget._currentUser
                                                            .interestedGender ==
                                                        '女性')
                                                    ? pink
                                                    : black87,
                                                fontSize: size.width * 0.05,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          widget._userFB.updateInterestedGender(
                                              widget._currentUser.uid, '女性');
                                          widget._currentUser.interestedGender =
                                              '女性';
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return HomeTab(
                                                  userFB: widget._userFB,
                                                  currentUser:
                                                      widget._currentUser,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      Divider(
                                        height: size.height * 0.01,
                                        color: black87,
                                      ),
                                      FlatButton(
                                        child: Container(
                                          height: size.height * 0.05,
                                          width: size.width * 0.8,
                                          child: Center(
                                            child: Text(
                                              "男性",
                                              style: TextStyle(
                                                color: (widget._currentUser
                                                            .interestedGender ==
                                                        '男性')
                                                    ? pink
                                                    : black87,
                                                fontSize: size.width * 0.05,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          widget._userFB.updateInterestedGender(
                                              widget._currentUser.uid, '男性');
                                          widget._currentUser.interestedGender =
                                              '男性';
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return HomeTab(
                                                  userFB: widget._userFB,
                                                  currentUser:
                                                      widget._currentUser,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      Divider(
                                        height: size.height * 0.01,
                                        color: black87,
                                      ),
                                      FlatButton(
                                        child: Container(
                                          height: size.height * 0.05,
                                          width: size.width * 0.8,
                                          child: Center(
                                            child: Text(
                                              "みんな",
                                              style: TextStyle(
                                                color: (widget._currentUser
                                                            .interestedGender ==
                                                        'みんな')
                                                    ? pink
                                                    : black87,
                                                fontSize: size.width * 0.05,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          widget._userFB.updateInterestedGender(
                                              widget._currentUser.uid, 'みんな');
                                          widget._currentUser.interestedGender =
                                              'みんな';
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return HomeTab(
                                                  userFB: widget._userFB,
                                                  currentUser:
                                                      widget._currentUser,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      Divider(
                                        height: size.height * 0.01,
                                        color: black87,
                                      ),

//                                    GestureDetector(
//                                      child: Container(
//                                        height: size.height * 0.05,
//                                        width: size.width * 0.6,
//                                        decoration: BoxDecoration(
//                                          border: Border.all(
//                                            color: pink,
//                                            width: size.height * 0.003,
//                                          ),
//                                          borderRadius:
//                                              BorderRadius.circular(100),
//                                        ),
//                                        child: Center(
//                                          child: Text(
//                                            "男性",
//                                            style: TextStyle(
//                                              color: pink,
//                                              fontSize: size.width * 0.05,
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                      onTap: () async {
//                                        Navigator.pop(context);
//                                        widget._userFB.updateInterestedGender(
//                                            widget._currentUser.uid, '男性');
//                                      },
//                                    ),
//                                    SizedBox(
//                                      height: size.height * 0.03,
//                                    ),
//                                    GestureDetector(
//                                      child: Container(
//                                        height: size.height * 0.05,
//                                        width: size.width * 0.6,
//                                        decoration: BoxDecoration(
//                                          border: Border.all(
//                                            color: pink,
//                                            width: size.height * 0.003,
//                                          ),
//                                          borderRadius:
//                                              BorderRadius.circular(100),
//                                        ),
//                                        child: Center(
//                                          child: Text(
//                                            "女性",
//                                            style: TextStyle(
//                                              color: pink,
//                                              fontSize: size.width * 0.05,
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                      onTap: () {
//                                        Navigator.pop(context);
//                                        widget._userFB.updateInterestedGender(
//                                            widget._currentUser.uid, '女性');
//                                      },
//                                    ),
//                                    SizedBox(
//                                      height: size.height * 0.03,
//                                    ),
//                                    GestureDetector(
//                                      child: Container(
//                                        height: size.height * 0.05,
//                                        width: size.width * 0.6,
//                                        decoration: BoxDecoration(
//                                          border: Border.all(
//                                            color: pink,
//                                            width: size.height * 0.003,
//                                          ),
//                                          borderRadius:
//                                              BorderRadius.circular(100),
//                                        ),
//                                        child: Center(
//                                          child: Text(
//                                            "みんな",
//                                            style: TextStyle(
//                                              color: pink,
//                                              fontSize: size.width * 0.05,
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                      onTap: () {
//                                        Navigator.pop(context);
//                                        widget._userFB.updateInterestedGender(
//                                            widget._currentUser.uid, 'みんな');
//                                      },
//                                    ),
//                                    SizedBox(
//                                      height: size.height * 0.02,
//                                    ),
                                    ],
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
                      width: size.width * 0.8,
                      child: Center(
                        child: Text(
                          '市町村区を表示',
                          style: TextStyle(
                            color: black87,
                            fontSize: size.width * 0.05,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: Text("街を表示する"),
                                content: Container(
                                  width: size.width * 0.9,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text('あなたの現在いる市町村区をプロフィールで表示します。'),
                                      SwitchListTile(
                                        activeColor: pink,
                                        value: _citySwitchValue,
                                        onChanged: (bool value) {
                                          setState(() {
                                            _citySwitchValue = value;
                                            if (value == true) {
                                              widget._userFB.hideCity(
                                                widget._currentUser.uid,
                                                true,
                                              );
                                            } else {
                                              widget._userFB.hideCity(
                                                widget._currentUser.uid,
                                                false,
                                              );
                                            }
                                          });
                                        },
                                      ),
                                    ],
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
//                  FlatButton(
//                    child: Container(
//                      height: size.height * 0.05,
//                      width: size.width * 0.8,
//                      child: Center(
//                        child: Text(
//                          'Keioboysで表示',
//                          style: TextStyle(
//                            color: black87,
//                            fontSize: size.width * 0.05,
//                          ),
//                        ),
//                      ),
//                    ),
//                    onPressed: () {
//                      showDialog(
//                        context: context,
//                        builder: (_) {
//                          return StatefulBuilder(
//                            builder: (context, setState) {
//                              return AlertDialog(
//                                // スイッチにする？(いつか)
//                                title: Text("Keioboysで表示する"),
//                                content: Container(
//                                  width: size.width * 0.9,
//                                  child: Column(
//                                    mainAxisSize: MainAxisSize.min,
//                                    children: <Widget>[
//                                      Text('非表示にするとあなたは新しい人に表示されなくなります。'),
//                                      Text('ただしあなたがすでにLIKEした人には表示されます。'),
//                                      SwitchListTile(
//                                        activeColor: pink,
//                                        value: _visibleSwitchValue,
//                                        onChanged: (bool value) {
//                                          setState(() {
//                                            _visibleSwitchValue = value;
//                                            if (value == true) {
//                                              widget._userFB.updateVisible(
//                                                widget._currentUser.uid,
//                                                true,
//                                              );
//                                            } else {
//                                              widget._userFB.updateVisible(
//                                                widget._currentUser.uid,
//                                                false,
//                                              );
//                                            }
//                                          });
//                                        },
//                                      ),
//                                    ],
//                                  ),
//                                ),
//                              );
//                            },
//                          );
//                        },
//                      );
//                    },
//                  ),
//                  Divider(
//                    color: black87,
//                  ),//TODO 非表示できないように
                  FlatButton(
                    child: Container(
                      height: size.height * 0.05,
                      width: size.width * 0.8,
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
                      showDialog(
                        context: context,
                        builder: (_) {
                          _newEmailController = TextEditingController();
                          _newEmailConfirmController = TextEditingController();
                          _passwordControllerForEmailChange =
                              TextEditingController();
                          bool loadingEmailChange = false;
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: GestureDetector(
                                    onTap: () =>
                                        FocusScope.of(context).unfocus(),
                                    child: AlertDialog(
                                      title: Text("メールアドレスの変更"),
                                      content: Container(
                                        width: size.width * 0.9,
                                        height: size.height * 0.6,
                                        child: Stack(
                                          children: <Widget>[
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "メールアドレスを変更するとログアウトします。新しいメールアドレスでもう一度ログインしてください。",
                                                  style: TextStyle(
                                                    color: black87,
                                                    fontSize:
                                                        size.width * 0.045,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.02,
                                                ),
                                                Text(
                                                  "現在のメールアドレス",
                                                  style: TextStyle(
                                                    color: black87,
                                                    fontSize: size.width * 0.04,
                                                  ),
                                                ),
                                                Text(
                                                  '${widget._currentUser.email}',
                                                  style: TextStyle(
                                                    color: black87,
                                                    fontSize: size.width * 0.04,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.02,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      _newEmailController,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  cursorColor: pink,
                                                  decoration: InputDecoration(
                                                    labelText: "新しいメールアドレス",
                                                    labelStyle: TextStyle(
                                                      color: black87,
                                                      fontSize:
                                                          size.width * 0.05,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: black87,
                                                        width:
                                                            size.width * 0.002,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: black87,
                                                        width:
                                                            size.width * 0.002,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.02,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      _newEmailConfirmController,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  cursorColor: pink,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        "新しいメールアドレス (確認)",
                                                    labelStyle: TextStyle(
                                                      color: black87,
                                                      fontSize:
                                                          size.width * 0.04,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: black87,
                                                        width:
                                                            size.width * 0.002,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: black87,
                                                        width:
                                                            size.width * 0.002,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.02,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      _passwordControllerForEmailChange,
                                                  obscureText:
                                                      !_showPasswordForEmailChange,
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  cursorColor: pink,
                                                  decoration: InputDecoration(
                                                    labelText: "パスワード",
                                                    labelStyle: TextStyle(
                                                      color: black87,
                                                      fontSize:
                                                          size.width * 0.05,
                                                    ),
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        _showPasswordForEmailChange
                                                            ? FontAwesomeIcons
                                                                .solidEyeSlash
                                                            : FontAwesomeIcons
                                                                .solidEye,
                                                        color: black54,
                                                        size: size.width * 0.05,
                                                      ),
                                                      onPressed: () {
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
                                                      borderSide: BorderSide(
                                                        color: black87,
                                                        width:
                                                            size.width * 0.002,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: black87,
                                                        width:
                                                            size.width * 0.002,
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
                                          splashColor: lightGrey,
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        FlatButton(
                                          child: Text(
                                            "変更",
                                            style: TextStyle(
                                              color: pink,
                                            ),
                                          ),
                                          splashColor: lightGrey,
                                          onPressed: () async {
                                            if (loadingEmailChange != true) {
                                              if (_newEmailController.text ==
                                                  _newEmailConfirmController
                                                      .text) {
                                                if (widget._currentUser
                                                            .gender ==
                                                        '男性' &&
                                                    !RegExp(r'[\w\-._]+@(keio.jp|jukuin.keio.ac.jp|akane.waseda.jp|asagi.waseda.jp|fuji.waseda.jp|moegi.waseda.jp|ruri.waseda.jp|suou.waseda.jp|toki.waseda.jp)')
                                                        .hasMatch(
                                                            _newEmailController
                                                                .text)) {
                                                  Flushbar(
                                                    message:
                                                        "慶應または早稲田の大学のメールアドレスを登録してください。",
                                                    backgroundColor: pink,
                                                    duration:
                                                        Duration(seconds: 3),
                                                  )..show(context);
                                                } else {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  loadingEmailChange = true;
                                                  String _result =
                                                      await _userFB.changeEmail(
                                                          password:
                                                              _passwordControllerForEmailChange
                                                                  .text,
                                                          newEmail:
                                                              _newEmailController
                                                                  .text);
                                                  if (_result == 'success') {
                                                    try {
                                                      Navigator.pop(context);
                                                      BlocProvider.of<AuthBloc>(
                                                              context)
                                                          .add(
                                                        LogOut(
                                                          currentUserId: widget
                                                              ._currentUser.uid,
                                                        ),
                                                      );
                                                      Navigator.pop(context);
                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return LoginPage(
                                                              userFB: _userFB,
                                                            );
                                                          },
                                                        ),
                                                        (_) => false,
                                                      );
                                                      Flushbar(
                                                        message:
                                                            "メールアドレスを変更しました。",
                                                        backgroundColor: pink,
                                                        duration: Duration(
                                                            seconds: 3),
                                                      )..show(context);
                                                    } catch (error) {
                                                      print('error: $error');
                                                      Flushbar(
                                                        message:
                                                            "しばらくしてからもう一度お試しください。",
                                                        backgroundColor: pink,
                                                        duration: Duration(
                                                            seconds: 3),
                                                      )..show(context);
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
                                                      message: "パスワードが間違っています。",
                                                      backgroundColor: pink,
                                                      duration:
                                                          Duration(seconds: 3),
                                                    )..show(context);
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
                                                      backgroundColor: pink,
                                                      duration:
                                                          Duration(seconds: 3),
                                                    )..show(context);
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
                                                      backgroundColor: pink,
                                                      duration:
                                                          Duration(seconds: 3),
                                                    )..show(context);
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
                      width: size.width * 0.8,
                      child: Center(
                        child: Text(
                          'パスワード変更',
                          style: TextStyle(
                            color: black87,
                            fontSize: size.width * 0.05,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          _newPasswordController = TextEditingController();
                          _passwordControllerForPasswordChange =
                              TextEditingController();
                          bool loadingPasswordChange = false;
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: GestureDetector(
                                    onTap: () =>
                                        FocusScope.of(context).unfocus(),
                                    child: AlertDialog(
                                      title: Text("パスワードの変更"),
                                      content: Container(
                                        width: size.width * 0.9,
                                        height: size.height * 0.28,
                                        child: Stack(
                                          children: <Widget>[
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: size.width * 0.05,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      _passwordControllerForPasswordChange,
                                                  obscureText:
                                                      !_showPasswordForPasswordChange,
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  cursorColor: pink,
                                                  decoration: InputDecoration(
                                                    labelText: "いまのパスワード",
                                                    labelStyle: TextStyle(
                                                      color: black87,
                                                      fontSize:
                                                          size.width * 0.05,
                                                    ),
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        _showPasswordForPasswordChange
                                                            ? FontAwesomeIcons
                                                                .solidEyeSlash
                                                            : FontAwesomeIcons
                                                                .solidEye,
                                                        color: black54,
                                                        size: size.width * 0.05,
                                                      ),
                                                      onPressed: () {
                                                        setState(
                                                          () {
                                                            _showPasswordForPasswordChange =
                                                                !_showPasswordForPasswordChange;
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: black87,
                                                        width:
                                                            size.width * 0.002,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: black87,
                                                        width:
                                                            size.width * 0.002,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.03,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      _newPasswordController,
                                                  obscureText:
                                                      !_showNewPassword,
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  cursorColor: pink,
                                                  decoration: InputDecoration(
                                                    labelText: "新しいパスワード",
                                                    labelStyle: TextStyle(
                                                      color: black87,
                                                      fontSize:
                                                          size.width * 0.05,
                                                    ),
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        _showNewPassword
                                                            ? FontAwesomeIcons
                                                                .solidEyeSlash
                                                            : FontAwesomeIcons
                                                                .solidEye,
                                                        color: black54,
                                                        size: size.width * 0.05,
                                                      ),
                                                      onPressed: () {
                                                        setState(
                                                          () {
                                                            _showNewPassword =
                                                                !_showNewPassword;
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: black87,
                                                        width:
                                                            size.width * 0.002,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: black87,
                                                        width:
                                                            size.width * 0.002,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            (loadingPasswordChange)
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
                                          splashColor: lightGrey,
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        FlatButton(
                                          child: Text(
                                            "変更",
                                            style: TextStyle(
                                              color: pink,
                                            ),
                                          ),
                                          splashColor: lightGrey,
                                          onPressed: () async {
                                            if (loadingPasswordChange != true) {
                                              String _result =
                                                  await _userFB.changePassword(
                                                      password:
                                                          _passwordControllerForPasswordChange
                                                              .text,
                                                      newPassword:
                                                          _newPasswordController
                                                              .text);
                                              if (_result == 'success') {
                                                Navigator.pop(context);
                                                Flushbar(
                                                  message: "パスワードを変更しました。",
                                                  backgroundColor: pink,
                                                  duration:
                                                      Duration(seconds: 3),
                                                )..show(context);
                                              } else if (_result ==
                                                  'ERROR_WRONG_PASSWORD') {
                                                Flushbar(
                                                  message: "いまのパスワードが間違っています。",
                                                  backgroundColor: pink,
                                                  duration:
                                                      Duration(seconds: 3),
                                                )..show(context);
                                                setState(() {
                                                  loadingPasswordChange = false;
                                                });
                                              } else if (_result ==
                                                  'ERROR_WEAK_PASSWORD') {
                                                Flushbar(
                                                  message:
                                                      "パスワードは6文字以上に設定してください。",
                                                  backgroundColor: pink,
                                                  duration:
                                                      Duration(seconds: 3),
                                                )..show(context);
                                                setState(() {
                                                  loadingPasswordChange = false;
                                                });
                                              } else {
                                                Flushbar(
                                                  message:
                                                      "しばらくしてからもう一度お試しください。",
                                                  backgroundColor: pink,
                                                  duration:
                                                      Duration(seconds: 3),
                                                )..show(context);
                                                setState(() {
                                                  loadingPasswordChange = false;
                                                });
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
                  (widget._currentUser.uid == "qAwfVRH2trZHFwd7W166EPrqiOZ2" ||
                          widget._currentUser.uid ==
                              "HSfllUIjFbeRJNlZssjqBsF79Gy2")
                      ? FlatButton(
                          //TODO アカウント削除させない
                          child: Container(
                            height: size.height * 0.05,
                            width: size.width * 0.8,
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
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            "アカウントを削除すると二度とこのアカウントにはログインできなくなります。",
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
                                          "いいえ",
                                          style: TextStyle(
                                            color: black87,
                                          ),
                                        ),
                                        splashColor: lightGrey,
                                        onPressed: () => Navigator.pop(context),
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
                                              _passwordControllerForDeleteAccount =
                                                  TextEditingController();
                                              bool loading = false;
                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return Center(
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child: GestureDetector(
                                                        onTap: () =>
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus(),
                                                        child: AlertDialog(
                                                          title:
                                                              Text("アカウントの削除"),
                                                          content: Container(
                                                            width: size.width *
                                                                0.9,
                                                            child: Stack(
                                                              children: <
                                                                  Widget>[
                                                                Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      'あなたに関するデータが正常に削除されない可能性があるので、絶対にアカウントの削除を中断しないでください。',
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
                                                                      height: size
                                                                              .width *
                                                                          0.05,
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
                                                                      controller:
                                                                          _passwordControllerForDeleteAccount,
                                                                      obscureText:
                                                                          !_showPassword,
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
                                                                              size.width * 0.05,
                                                                        ),
                                                                        suffixIcon:
                                                                            IconButton(
                                                                          icon:
                                                                              Icon(
                                                                            _showPassword
                                                                                ? FontAwesomeIcons.solidEyeSlash
                                                                                : FontAwesomeIcons.solidEye,
                                                                            color:
                                                                                black54,
                                                                            size:
                                                                                size.width * 0.05,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            setState(
                                                                              () {
                                                                                _showPassword = !_showPassword;
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
                                                                            width:
                                                                                size.width * 0.002,
                                                                          ),
                                                                        ),
                                                                        enabledBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color:
                                                                                black87,
                                                                            width:
                                                                                size.width * 0.002,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                (loading)
                                                                    ? Center(
                                                                        heightFactor:
                                                                            size.height *
                                                                                0.01,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation(pink),
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
                                                                    color:
                                                                        black87),
                                                              ),
                                                              splashColor:
                                                                  lightGrey,
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                            FlatButton(
                                                              child: Text(
                                                                "削除",
                                                                style: TextStyle(
                                                                    color:
                                                                        pink),
                                                              ),
                                                              splashColor:
                                                                  lightGrey,
                                                              onPressed:
                                                                  () async {
                                                                if (loading !=
                                                                    true) {
                                                                  if (_passwordControllerForDeleteAccount
                                                                          .text
                                                                          .length ==
                                                                      0) {
                                                                    Flushbar(
                                                                      message:
                                                                          "パスワードを入力してください。",
                                                                      backgroundColor:
                                                                          pink,
                                                                      duration: Duration(
                                                                          seconds:
                                                                              3),
                                                                    )..show(
                                                                        context);
                                                                  } else if (_passwordControllerForDeleteAccount
                                                                          .text
                                                                          .length <
                                                                      6) {
                                                                    Flushbar(
                                                                      message:
                                                                          "パスワードを6字以上で入力してください。",
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
                                                                    setState(
                                                                        () {
                                                                      loading =
                                                                          true;
                                                                    });

                                                                    String
                                                                        _resultReAuth =
                                                                        await _userFB
                                                                            .reAuthenticate(_passwordControllerForDeleteAccount.text);
                                                                    if (_resultReAuth ==
                                                                        'success') {
                                                                      String
                                                                          _result =
                                                                          await _userFB
                                                                              .deleteAccount(_passwordControllerForDeleteAccount.text);
                                                                      if (_result ==
                                                                          'success') {
                                                                        _passwordControllerForDeleteAccount.text =
                                                                            '';
                                                                        _passwordControllerForDeleteAccount
                                                                            .clear();
                                                                        BlocProvider.of<AuthBloc>(context)
                                                                            .add(
                                                                          Deleted(),
                                                                        );
                                                                        Timer(
                                                                            Duration(milliseconds: 300),
                                                                            () {
                                                                          Navigator.of(context).pushAndRemoveUntil(
                                                                              MaterialPageRoute(
                                                                            builder:
                                                                                (context) {
                                                                              return LoginPage(userFB: _userFB);
                                                                            },
                                                                          ), (_) => false);
                                                                          Flushbar(
                                                                            message:
                                                                                "アカウントを削除しました。",
                                                                            backgroundColor:
                                                                                pink,
                                                                            duration:
                                                                                Duration(seconds: 3),
                                                                          )..show(
                                                                              context);
                                                                        });
                                                                      } else {
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
                                                                          loading =
                                                                              false;
                                                                        });
                                                                      }
                                                                    } else if (_resultReAuth ==
                                                                        'wrong-password') {
                                                                      Flushbar(
                                                                        message:
                                                                            "パスワードが間違っています。",
                                                                        backgroundColor:
                                                                            pink,
                                                                        duration:
                                                                            Duration(seconds: 3),
                                                                      )..show(
                                                                          context);
                                                                      setState(
                                                                          () {
                                                                        loading =
                                                                            false;
                                                                      });
                                                                    } else {
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
                                                                        loading =
                                                                            false;
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
                        )
                      : Container(),
                  (widget._currentUser.uid == "2g45QEuchUcDgBFZNc0HMgtdLWF3" ||
                          widget._currentUser.uid ==
                              "HSfllUIjFbeRJNlZssjqBsF79Gy2")
                      ? Divider(
                          color: black87,
                        )
                      : Container(), //TODO aアカウント削除ここまで
                  FlatButton(
                      child: Container(
                        height: size.height * 0.05,
                        width: size.width * 0.8,
                        child: Center(
                          child: Text(
                            'ログアウト',
                            style: TextStyle(
                              color: black87,
                              fontSize: size.width * 0.05,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: Text("ログアウト"),
                                  content: Container(
                                    width: size.width * 0.9,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        "キャンセル",
                                        style: TextStyle(color: black87),
                                      ),
                                      splashColor: lightGrey,
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    FlatButton(
                                      splashColor: lightGrey,
                                      child: Text(
                                        "ログアウト",
                                        style: TextStyle(color: pink),
                                      ),
                                      onPressed: () async {
                                        try {
                                          BlocProvider.of<AuthBloc>(context)
                                              .add(LogOut(
                                            currentUserId:
                                                widget._currentUser.uid,
                                          ));
                                          Navigator.pop(context);
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                            builder: (context) {
                                              return LoginPage(userFB: _userFB);
                                            },
                                          ), (_) => false);

                                          Flushbar(
                                            message: "ログアウトしました。",
                                            backgroundColor: pink,
                                            duration: Duration(seconds: 3),
                                          )..show(context);
                                        } catch (error) {
                                          Flushbar(
                                            message: "しばらくしてからもう一度お試しください。",
                                            backgroundColor: pink,
                                            duration: Duration(seconds: 3),
                                          )..show(context);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }),
                  Divider(
                    height: size.height * 0.01,
                    color: black87,
                  ),
                  FlatButton(
                    child: Container(
                      height: size.height * 0.05,
                      width: size.width * 0.8,
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
                      showDialog(
                        context: context,
                        builder: (_) {
                          return StatefulBuilder(builder: (context, setState) {
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
                                      height: size.height * 0.03,
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
                                  splashColor: lightGrey,
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            );
                          });
                        },
                      );
                    },
                  ),
                  Divider(
                    height: size.height * 0.01,
                    color: black87,
                  ),
                  FlatButton(
                    child: Container(
                      height: size.height * 0.05,
                      width: size.width * 0.8,
                      child: Center(
                        child: Text(
                          '改善点を送る',
                          style: TextStyle(
                            color: black87,
                            fontSize: size.width * 0.05,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (_) {
                          TextEditingController _textControllerForOpinion =
                              TextEditingController();
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: GestureDetector(
                                    onTap: () =>
                                        FocusScope.of(context).unfocus(),
                                    child: AlertDialog(
                                      title: Text("改善点を送る"),
                                      content: Container(
                                        width: size.width * 0.9,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              'ご協力ありがとうございます。皆様により良い体験をしていただくため運営チーム一同努めてまいります。',
                                              style: TextStyle(
                                                color: black87,
                                                fontSize: size.width * 0.05,
                                              ),
                                            ),
                                            SizedBox(
                                              height: size.width * 0.05,
                                            ),
                                            TextFormField(
                                              controller:
                                                  _textControllerForOpinion,
                                              cursorColor: pink,
                                              decoration: InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: black87,
                                                    width: size.width * 0.002,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: black87,
                                                    width: size.width * 0.002,
                                                  ),
                                                ),
                                                labelText: '改善点',
                                                labelStyle: TextStyle(
                                                  color: black87,
                                                ),
                                              ),
                                              autofocus: true,
                                              minLines: 4,
                                              maxLines: null,
                                              maxLengthEnforcement:
                                                  MaxLengthEnforcement.none,
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          splashColor: lightGrey,
                                          child: Text(
                                            "送信",
                                            style: TextStyle(
                                              color: pink,
                                            ),
                                          ),
                                          onPressed: () {
                                            _messageFB.sendOpinion(
                                              currentUserId:
                                                  widget._currentUser.uid,
                                              opinion: _textControllerForOpinion
                                                  .text,
                                            );
                                            Navigator.of(context).pop();
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
                    height: size.height * 0.01,
                    color: black87,
                  ),
                  FlatButton(
                    child: Container(
                      height: size.height * 0.05,
                      width: size.width * 0.8,
                      child: Center(
                        child: Text(
                          '利用規約・プライバシーポリシー',
                          style: TextStyle(
                            color: black87,
                            fontSize: size.width * 0.045,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                content: Container(
                                  width: size.width * 0.9,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      FlatButton(
                                        child: Container(
                                          height: size.height * 0.05,
                                          width: size.width * 0.8,
                                          child: Center(
                                            child: Text(
                                              "利用規約",
                                              style: TextStyle(
                                                color: black87,
                                                fontSize: size.width * 0.05,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                            slideRoute(
                                              TermsOfServicePage(),
                                            ),
                                          );
                                        },
                                      ),
                                      Divider(
                                        height: size.height * 0.01,
                                        color: black87,
                                      ),
                                      FlatButton(
                                        child: Container(
                                          height: size.height * 0.05,
                                          width: size.width * 0.8,
                                          child: Center(
                                            child: Text(
                                              "プライバシーポリシー",
                                              style: TextStyle(
                                                color: black87,
                                                fontSize: size.width * 0.05,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
//                                        Crashlytics.instance.crash();
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                            slideRoute(
                                              PrivacyPolicyPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
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
                    height: size.height * 0.01,
                    color: black87,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
