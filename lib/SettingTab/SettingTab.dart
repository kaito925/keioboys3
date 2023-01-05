import 'dart:async';
import 'dart:ui';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Keioboys/SettingTab/HowToUsePage.dart';
import 'package:Keioboys/Widgets/SlideRoute.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:Keioboys/SettingTab/EditingPage.dart';
import 'package:Keioboys/SettingTab/PremiumPage.dart';
import 'package:Keioboys/SettingTab/SettingPage.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:Keioboys/Widgets/ShowImageFromURL.dart';
import 'package:flutter/material.dart';
import 'package:Keioboys/Widgets/CircleButton.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:Keioboys/Widgets/CalculateAge.dart';
import 'package:Keioboys/SettingTab/MyProfPage.dart';
import 'package:Keioboys/consts.dart';
import 'package:Keioboys/Widgets/fake_ui.dart' if (dart.library.html) 'dart:ui'
    as ui;
import 'package:universal_html/html.dart' as html;

class SettingTab extends StatefulWidget {
  final UserData _currentUser;
  final UserFB _userFB;

  SettingTab({String userId, @required UserData currentUser, UserFB userFB})
      : assert(currentUser != null),
        _userFB = userFB,
        _currentUser = currentUser;

  @override
  _SettingTabState createState() => _SettingTabState();
}

class NotifyString {
  final String title;
  final String firstLine;
  final String secondLine;
  NotifyString({
    this.title,
    this.firstLine,
    this.secondLine,
  });
}

class _SettingTabState extends State<SettingTab>
    with AutomaticKeepAliveClientMixin<SettingTab> {
  final StreamController _streamController = StreamController.broadcast();
  int currentPage = 0;
  int currentColor = 0;
  bool reverse = false;
  PageController _controller = PageController();
  Timer _pageChangeTimer;
  Timer colorTimer;
  UserData _currentUser;
  Size size;
  List settingTabTextList;

  @override
  void initState() {
    getSettingTabText();
    super.initState();
  }

  getSettingTabText() async {
    settingTabTextList = await widget._userFB.getSettingTabText();
    _streamController.add(settingTabTextList);
  }

  @override
  void dispose() {
    // _pageChangeTimer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl2;
    if (web) {
      imageUrl2 = widget._currentUser.photo1;
      ui.platformViewRegistry.registerViewFactory(
        imageUrl2,
        (int _) => html.ImageElement()..src = imageUrl2,
      );
    }
    size = MediaQuery.of(context).size;
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: size.height * 0.12,
              ),
              Container(
                height: size.width * 0.3,
                width: size.width * 0.3,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(size.width * 0.15),
                      child: Container(
                        height: size.width * 0.3,
                        width: size.width * 0.3,
                        child: (_currentUser != null)
                            ? (_currentUser.photo1 != null)
                                ? (web)
                                    ? imageURL1(imageUrl1: _currentUser.photo1)
//                    HtmlElementView(
//                                    viewType: imageUrl2,
//                                    viewType: imageUrl1,
//                                  )
                                    : ShowImageFromURL(
                                        photoURL: _currentUser.photo1,
                                      )
                                : (widget._currentUser.photo1 != null)
                                    ? (web)
                                        ? HtmlElementView(
//                                        viewType: imageUrl1,
                                            viewType: imageUrl2,
                                          )
                                        : ShowImageFromURL(
                                            photoURL:
                                                widget._currentUser.photo1,
                                          )
                                    : Container()
                            : (widget._currentUser.photo1 != null)
                                ? (web)
                                    ? HtmlElementView(
//                                    viewType: imageUrl1,
                                        viewType: imageUrl2,
                                      )
                                    : ShowImageFromURL(
                                        photoURL: widget._currentUser.photo1,
                                      )
                                : Container(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        UserData currentUser = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MyProfPage(
                              currentUser: (_currentUser == null)
                                  ? widget._currentUser
                                  : _currentUser,
                              userFB: widget._userFB,
                            ),
                          ),
                        );
                        setState(() => _currentUser = currentUser);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Text(
                (_currentUser == null)
                    ? "${widget._currentUser.name} (${calculateAge(widget._currentUser.birthday)})"
                    : "${_currentUser.name} (${calculateAge(_currentUser.birthday)})",
                style: TextStyle(
                    fontSize: size.width * 0.05, fontWeight: FontWeight.bold),
              ),
//          new SizedBox(
//            height: size.height * 0.01,
//          ),
//          new Text(
//            (_currentUser == null)
//                ? "${widget._currentUser.city}"
//                : "${_currentUser.city}",
//            style: TextStyle(
//              fontSize: size.height * 0.018,
//            ),
//          ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: size.width * 0.08,
                  right: size.width * 0.08,
                ),
                height: size.height * 0.22,
//                height: size.height * 0.18,
                child: StreamBuilder(
                  stream: _streamController.stream,
                  builder: (context, snapshot) {
                    return (settingTabTextList == null)
                        ? Container()
                        : PageIndicatorContainer(
//                    size: size.height * 0.01,
                            indicatorSpace: size.width * 0.02,
                            indicatorSelectorColor: pink,
                            indicatorColor: Colors.grey.withOpacity(0.5),
                            child: PageView.builder(
                              controller: _controller,
//              onPageChanged: _onPageChanged,
                              itemCount: settingTabTextList.length,
                              itemBuilder: (c, index) {
                                return Column(
                                  children: <Widget>[
                                    Text(
                                      settingTabTextList[index].title,
                                      style: TextStyle(
                                        color: black,
                                        fontSize: size.width * 0.045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    (settingTabTextList[index].title != '')
                                        ? SizedBox(
                                            height: size.width * 0.02,
                                          )
                                        : Container(),
                                    Text(
                                      settingTabTextList[index].firstLine,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: size.width * 0.045,
                                        color: black87,
                                      ),
                                    ),
                                    Text(
                                      settingTabTextList[index].secondLine,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: size.width * 0.045,
                                        color: black87,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            length: settingTabTextList.length,
                          );
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.08,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
//                  FlatButton(
//                    child: Container(
//                      width: size.width * 0.22,
//                      height: size.width * 0.2,
//                      decoration: BoxDecoration(
//                        border: Border.all(
//                          color: pink,
//                          width: size.width * 0.0025,
//                        ),
//                        borderRadius: BorderRadius.circular(
//                          10,
//                        ),
//                      ),
//                      child: Center(
//                        child: Text(
//                          '使い方',
//                          style: TextStyle(
//                            fontSize: size.width * 0.05,
//                            color: pink,
//                          ),
//                        ),
//                      ),
//                    ),
//                   circleButton(
//                     icon: FontAwesomeIcons.question,
//                     color: pink,
//                     size: size.width * 0.17,
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         slideRoute(
//                           HowToUsePage(),
//                         ),
//                       );
//                     },
//                   ),
//                  FlatButton(
//                    child: Container(
//                      width: size.width * 0.22,
//                      height: size.width * 0.2,
//                      decoration: BoxDecoration(
//                        border: Border.all(
//                          color: pink,
//                          width: size.width * 0.0025,
//                        ),
//                        borderRadius: BorderRadius.circular(
//                          10,
//                        ),
//                      ),
//                      child: Center(
//                        child: Text(
//                          '設定',
//                          style: TextStyle(
//                            fontSize: size.width * 0.05,
//                            color: pink,
//                          ),
//                        ),
//                      ),
//                    ),
                  circleButton(
                    icon: Icons.settings,
                    color: pink,
                    size: size.width * 0.17,
                    onPressed: () {
                      Navigator.of(context).push(
                        slideRoute(
                          SettingPage(
                            userFB: widget._userFB,
                            currentUser: widget._currentUser,
                          ),
                        ),
                      );
                    },
                  ),
//                  FlatButton(
//                    child: Container(
//                      width: size.width * 0.22,
//                      height: size.width * 0.2,
//                      decoration: BoxDecoration(
//                        border: Border.all(
//                          color: pink,
//                          width: size.width * 0.0025,
//                        ),
//                        borderRadius: BorderRadius.circular(
//                          10,
//                        ),
//                      ),
//                      child: Center(
//                        child: Text(
//                          '編集',
//                          style: TextStyle(
//                            fontSize: size.width * 0.05,
//                            color: pink,
//                          ),
//                        ),
//                      ),
//                    ),
                  circleButton(
                    icon: Icons.edit,
                    color: pink,
                    size: size.width * 0.17,
                    onPressed: () async {
                      UserData currentUser = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditingPage(
                            currentUser: (_currentUser == null)
                                ? widget._currentUser
                                : _currentUser,
                            userFB: widget._userFB,
                            noName: false,
                            fromEdit: false,
                          ),
                        ),
                      );
                      setState(() => _currentUser = currentUser);
                    },
                  ),

//                  circleButton(
//                    icon: FontAwesomeIcons.question,
//                    color: pink,
//                    size: size.width * 0.17,
//                    onPressed: () {
//                      Navigator.of(context).push(
//                        slideRoute(
//                          HowToUsePage(),
//                        ),
//                      );
//                    },
//                  ),
//                  circleButton(
//                    icon: Icons.settings,
//                    color: pink,
//                    size: size.width * 0.17,
//                    onPressed: () {
//                      Navigator.of(context).push(
//                        slideRoute(
//                          SettingPage(
//                            userFB: widget._userFB,
//                            currentUser: widget._currentUser,
//                          ),
//                        ),
//                      );
//                    },
//                  ),

//                  Container(
//                    width: size.height * 0.17,
//                    height: size.height * 0.17,
//                    decoration: BoxDecoration(
//                        shape: BoxShape.circle,
//                        color: white,
//                        boxShadow: [
//                          BoxShadow(
//                              color: Colors.black.withAlpha(50),
//                              blurRadius: 10.0,
//                              spreadRadius: 1)
//                        ]),
//                    child: RaisedButton(
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          Text(
//                            "Stars",
//                            style: TextStyle(
//                              color: pink,
//                              fontSize: size.height * 0.02,
//                            ),
//                          ),
//                          Text(
//                            "プレミアム",
//                            style: TextStyle(
//                              color: pink,
//                              fontSize: size.height * 0.02,
//                            ),
//                          ),
//                        ],
//                      ),
//                      color: white,
////                  padding: EdgeInsets.symmetric(
////                    horizontal: size.height * 0.055,
////                    vertical: size.height * 0.025,
////                  ),
//                      shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(100),
//                      ),
//                      onPressed: () {
//                        Navigator.of(context).push(
//                          MaterialPageRoute(
//                            builder: (context) {
//                              return PremiumPage(
//                                userFB: widget._userFB,
//                                userId: widget._currentUser.uid,
//                              );
//                            },
//                          ),
//                        );
//                      },
//                    ),
//                  ),//プレミアム追加（こんど）

//              RaisedButton(
//                child: Icon(
//                  Icons.edit,
//                  color: pink,
//                ),
//                color: white,
//                padding: EdgeInsets.symmetric(
//                  horizontal: size.height * 0.025,
//                  vertical: size.height * 0.025,
//                ),
//                shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(100),
//                ),
//                onPressed: () {
//                  Navigator.of(context).push(
//                    MaterialPageRoute(
//                      builder: (context) {
//                        return PremiumPage(
//                          userRepo: widget._userRepo,
//                          userId: widget._userId,
//                        );
//                      },
//                    ),
//                  );
//                },
//              ),

//                  circleButton(
//                    icon: Icons.edit,
//                    color: pink,
//                    size: size.width * 0.17,
//                    onPressed: () async {
//                      UserData currentUser = await Navigator.of(context).push(
//                        MaterialPageRoute(
//                          builder: (context) => EditingPage(
//                            currentUser: (_currentUser == null)
//                                ? widget._currentUser
//                                : _currentUser,
//                            userFB: widget._userFB,
//                            noName: false,
//                            fromEdit: false,
//                          ),
//                        ),
//                      );
//                      setState(() => _currentUser = currentUser);
//                    },
//                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageURL1({String imageUrl1}) {
    if (web) {
      ui.platformViewRegistry.registerViewFactory(
        imageUrl1,
        (int _) => html.ImageElement()..src = imageUrl1,
      );
    }
    return HtmlElementView(
      viewType: imageUrl1,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
