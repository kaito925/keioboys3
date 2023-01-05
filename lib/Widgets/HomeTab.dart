//著作ok

import 'dart:async';

import 'package:Keioboys/MessageTab/AgeVerificationPage.dart';
import 'package:Keioboys/MessageTab/MessageListPage.dart';
import 'package:Keioboys/Search/SearchNewPage.dart';
import 'package:Keioboys/SettingTab/SettingTab.dart';
import 'package:Keioboys/MessageTab/MessageTab.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:Keioboys/Widgets/CheckCountinueApp.dart';
import '../consts.dart';
import 'package:Keioboys/Widgets/UserData.dart';

import 'AppBar.dart';
import 'package:Keioboys/Widgets/CheckLocationEnabled.dart';

class HomeTab extends StatefulWidget {
  final UserFB _userFB;
  final UserData _currentUser;
  //  final bool _fromMain;
//  final String matchPhoto;
//  final String matchName;

  HomeTab({
    Key key,
    @required UserFB userFB,
    @required UserData currentUser,
//    bool fromMain,
//    this.matchPhoto,
//    this.matchName,
  })  : assert(userFB != null),
        _userFB = userFB,
        _currentUser = currentUser,
//        _fromMain = fromMain,
        super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  UserFB get _userFB => widget._userFB;
//  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final controller = PageController();
//  int count;

  @override
  void initState() {
    print('initState: HomeTab');
//    count = 1;
    super.initState();
  }

//  void appOpenUpdate() {
//    print('appOpen');
//    Size size = MediaQuery.of(context).size;
//    _firebaseMessaging.requestNotificationPermissions(
//        const IosNotificationSettings(sound: true, badge: true, alert: true));
//    _firebaseMessaging.onIosSettingsRegistered
//        .listen((IosNotificationSettings settings) {});
//    _firebaseMessaging.getToken().then((String token) async {
//      assert(token != null);
//      print('currentUserId: ${widget._currentUser.uid}');
//      checkLocationEnabled(
//        size: size,
//        context: context,
//      );
//      _userFB.updateInfo(
//        currentUser: widget._currentUser,
//        token: token,
//        context: context,
//      );
//    });
//  }

  @override
  Widget build(BuildContext context) {
    checkContinueApp(context);
//    if (widget._fromMain == true && count == 1) {
//      appOpenUpdate();
//      count = count + 1;
//    }

    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: appBar(),
        body: WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: TabBarView(
            children: [
              SettingTab(
                userFB: _userFB,
                currentUser: widget._currentUser,
              ),
              SearchNewPage(
                currentUser: widget._currentUser,

//        matchPhoto: widget.matchPhoto,
//        matchName: widget.matchName,
              ),
//              (widget._currentUser.ageVerification == true)
//                  ?
              MessageListPage(
                currentUser: widget._currentUser,
              ),
//               MessageTab(
//                 userFB: _userFB,
//                 currentUser: widget._currentUser,
//               )
//                  : AgeVerificationPage(
//                      userFB: _userFB,
//                      currentUser: widget._currentUser,
//                    ),
            ],
          ),
        ),
      ),
    );
  }
}

/*bottomNavigationBar: BottomBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      )*/
