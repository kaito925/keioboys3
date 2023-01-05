//著作ok

import 'package:Keioboys/Search/Prof/Prof1AndBack.dart';
import 'package:Keioboys/Search/Prof/Prof2.dart';
import 'package:Keioboys/Search/Prof/Prof3.dart';
import 'package:Keioboys/Search/Prof/Prof4.dart';
import 'package:Keioboys/Search/Prof/Prof5.dart';
import 'package:Keioboys/Search/Prof/Prof6.dart';
import 'package:Keioboys/Search/Prof/ProfDetail1.dart';
import 'package:Keioboys/Search/Prof/ProfDetail2.dart';
import 'package:Keioboys/Search/Prof/ProfDetail3.dart';
import 'package:Keioboys/Search/Prof/ProfDetail4.dart';
import 'package:Keioboys/Search/Prof/ProfDetail5.dart';
import 'package:Keioboys/Search/Prof/ProfDetail6.dart';
import 'package:Keioboys/SettingTab/EditingPage.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:Keioboys/consts.dart';
import 'package:Keioboys/Widgets/CircleButton.dart';
import 'package:flutter/material.dart';
import 'package:Keioboys/Widgets/UserData.dart';

class MyProfPage extends StatefulWidget {
  final UserFB _userFB;
  final UserData _currentUser;

  MyProfPage({String userId, UserData currentUser, UserFB userFB})
      : assert(currentUser != null),
        _userFB = userFB,
        _currentUser = currentUser;

  @override
  _MyProfPageState createState() => _MyProfPageState();
}

class _MyProfPageState extends State<MyProfPage> {
  UserData _currentUser;
  String photoShow;
  Key _frontProfKey;
  bool detail;
  int photoCount;
  int photoNumber;

  @override
  void initState() {
    _frontProfKey = Key(widget._currentUser.uid);
    detail = false;
    photoNumber = 1;
    photoCount = 0;
    if (widget._currentUser.photo1 != null &&
        widget._currentUser.photo1 != '') {
      photoCount++;
    }
    if (widget._currentUser.photo2 != null &&
        widget._currentUser.photo2 != '') {
      photoCount++;
    }
    if (widget._currentUser.photo3 != null &&
        widget._currentUser.photo3 != '') {
      photoCount++;
    }
    if (widget._currentUser.photo4 != null &&
        widget._currentUser.photo4 != '') {
      photoCount++;
    }
    if (widget._currentUser.photo5 != null &&
        widget._currentUser.photo5 != '') {
      photoCount++;
    }
    if (widget._currentUser.photo6 != null &&
        widget._currentUser.photo6 != '') {
      photoCount++;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop((_currentUser == null)
            ? widget._currentUser
            : _currentUser); //引数わたしてもどる
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          brightness: Brightness.light,
          title: Text(
            'Myプロフィール',
            style: TextStyle(
              color: pink,
            ),
          ),
          iconTheme: IconThemeData(
            color: pink,
          ),
          backgroundColor: white,
          automaticallyImplyLeading: false,
//            elevation: 0,
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              alignment: Alignment.center,
              height: size.width * 1.5,
//              (size.height -
//                          size.width * 0.215 -
//                          AppBar().preferredSize.height >
//                      size.width * 1.5)
//                  ? size.width * 1.5
//                  : size.height -
//                      size.width * 0.215 -
//                      AppBar().preferredSize.height,
              width: size.width,
//              (size.height -
//                          size.width * 0.215 -
//                          AppBar().preferredSize.height >
//                      size.width * 1.5)
//                  ? size.width
//                  : (size.height -
//                          size.width * 0.215 -
//                          AppBar().preferredSize.height) *
//                      0.75,
              padding: EdgeInsets.only(
                top: size.height * 0.01,
                left: size.width * 0.012,
                right: size.width * 0.012,
                bottom: size.height * 0.007,
              ),
              child: (photoNumber == 1)
                  ? (detail == false)
                      ? GestureDetector(
                          child: _prof1(),
                          onTapUp: _onTapUp,
                        )
                      : _profDetail1()
                  : (photoNumber == 2)
                      ? (detail == false)
                          ? GestureDetector(
                              child: _prof2(),
                              onTapUp: _onTapUp,
                            )
                          : _profDetail2()
                      : (photoNumber == 3)
                          ? (detail == false)
                              ? GestureDetector(
                                  child: _prof3(),
                                  onTapUp: _onTapUp,
                                )
                              : _profDetail3()
                          : (photoNumber == 4)
                              ? (detail == false)
                                  ? GestureDetector(
                                      child: _prof4(),
                                      onTapUp: _onTapUp,
                                    )
                                  : _profDetail4()
                              : (photoNumber == 5)
                                  ? (detail == false)
                                      ? GestureDetector(
                                          child: _prof5(),
                                          onTapUp: _onTapUp,
                                        )
                                      : _profDetail5()
                                  : (detail == false)
                                      ? GestureDetector(
                                          child: _prof6(),
                                          onTapUp: _onTapUp,
                                        )
                                      : _profDetail6(),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: transparent,
          elevation: 0.0,
          child: Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.04,
              right: size.width * 0.04,
              top: size.width * 0.015,
              bottom: size.width * 0.03,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                circleButton(
                  icon: Icons.arrow_back,
                  color: pink,
                  size: size.width * 0.17,
                  onPressed: () {
                    Navigator.of(context).pop((_currentUser == null)
                        ? widget._currentUser
                        : _currentUser);
                  },
                ),
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
                          fromEdit: true,
                        ),
                      ),
                    );
                    setState(
                      () => _currentUser = currentUser,
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

  Widget _prof1() {
    return Prof1AndBack(
      key: _frontProfKey,
      fromMyProf: true,
//              distanceFront: distanceFront,
      currentUser: widget._currentUser,
      searchUser: widget._currentUser,
//              swipeDecision: widget.profIndex.currentProf.swipeDecision,
//              showingDecision: decisionIndicator,
      isDraggable: false,
//              update: widget.update,
//              callback: (String decision) {
//                setState(() {
//                  buttonDecision = decision;
//                  print('buttonDecision: $buttonDecision');
//                });
//              }),
    );
  }

  Widget _prof2() {
    return Prof2(
      key: _frontProfKey,
      distanceFront: 0,
      currentUser: widget._currentUser,
      searchUser: widget._currentUser,
//              swipeDecision: widget.profIndex.currentProf.swipeDecision,
//              showingDecision: decisionIndicator,
      isDraggable: false,
//              update: widget.update,
//              callback: (String decision) {
//                setState(() {
//                  buttonDecision = decision;
//                  print('buttonDecision: $buttonDecision');
//                });
//              }),
    );
  }

  Widget _prof3() {
    return Prof3(
      key: _frontProfKey,
      distanceFront: 0,
      currentUser: widget._currentUser,
      searchUser: widget._currentUser,
//              swipeDecision: widget.profIndex.currentProf.swipeDecision,
//              showingDecision: decisionIndicator,
      isDraggable: false,
//              update: widget.update,
//              callback: (String decision) {
//                setState(() {
//                  buttonDecision = decision;
//                  print('buttonDecision: $buttonDecision');
//                });
//              }),
    );
  }

  Widget _prof4() {
    return Prof4(
      key: _frontProfKey,
      distanceFront: 0,
      currentUser: widget._currentUser,
      searchUser: widget._currentUser,
//              swipeDecision: widget.profIndex.currentProf.swipeDecision,
//              showingDecision: decisionIndicator,
      isDraggable: false,
//              update: widget.update,
//              callback: (String decision) {
//                setState(() {
//                  buttonDecision = decision;
//                  print('buttonDecision: $buttonDecision');
//                });
//              }),
    );
  }

  Widget _prof5() {
    return Prof5(
      key: _frontProfKey,
      distanceFront: 0,
      currentUser: widget._currentUser,
      searchUser: widget._currentUser,
//              swipeDecision: widget.profIndex.currentProf.swipeDecision,
//              showingDecision: decisionIndicator,
      isDraggable: false,
//              update: widget.update,
//              callback: (String decision) {
//                setState(() {
//                  buttonDecision = decision;
//                  print('buttonDecision: $buttonDecision');
//                });
//              }),
    );
  }

  Widget _prof6() {
    return Prof6(
      key: _frontProfKey,
      distanceFront: 0,
      currentUser: widget._currentUser,
      searchUser: widget._currentUser,
//              swipeDecision: widget.profIndex.currentProf.swipeDecision,
//              showingDecision: decisionIndicator,
      isDraggable: false,
//              update: widget.update,
//              callback: (String decision) {
//                setState(() {
//                  buttonDecision = decision;
//                  print('buttonDecision: $buttonDecision');
//                });
//              }),
    );
  }

  Widget _profDetail1() {
    return ProfDetail(
      key: _frontProfKey,
      distanceFront: 0,
      currentUser: widget._currentUser,
      searchUser: widget._currentUser,
//      swipeDecision: widget.profIndex.currentProf.swipeDecision,
//      region: decisionIndicator,
      isDraggable: false,
//      update: widget.update,
      photoNumber: photoNumber,
      photoCount: photoCount,
      photoNumberCallback: (int photoNumberCallback) {
        setState(() {
          photoNumber = photoNumberCallback;
          detail = true;
        });
      },
//      callback: (String decision) {
//        setState(() {
//          buttonDecision = decision;
//          detail = false;
//          buildUnDetailFirst = true;
//          print('buttonDecision: $buttonDecision');
//          getDistance(widget.profIndex.currentProf.searchUser.location);
//        });
//      },
      detailCallback: (bool detailCallBack) {
        if (detailCallBack == false) {
          setState(() {
            detail = false;
          });
        }
      },
    );
  }

  Widget _profDetail2() {
    return ProfDetail2(
      key: _frontProfKey,
      distanceFront: 0,
      currentUser: widget._currentUser,
      searchUser: widget._currentUser,
//      swipeDecision: widget.profIndex.currentProf.swipeDecision,
//      region: decisionIndicator,
      isDraggable: false,
//      update: widget.update,
      photoNumber: photoNumber,
      photoCount: photoCount,
      photoNumberCallback: (int photoNumberCallback) {
        setState(() {
          photoNumber = photoNumberCallback;
          detail = true;
        });
      },
//      callback: (String decision) {
//        setState(() {
//          buttonDecision = decision;
//          detail = false;
//          buildUnDetailFirst = true;
//          print('buttonDecision: $buttonDecision');
//          getDistance(widget.profIndex.currentProf.searchUser.location);
//        });
//      },
      detailCallback: (bool detailCallBack) {
        if (detailCallBack == false) {
          setState(() {
            detail = false;
          });
        }
      },
    );
  }

  Widget _profDetail3() {
    return ProfDetail3(
      key: _frontProfKey,
      distanceFront: 0,
      currentUser: widget._currentUser,
      searchUser: widget._currentUser,
//      swipeDecision: widget.profIndex.currentProf.swipeDecision,
//      region: decisionIndicator,
      isDraggable: false,
//      update: widget.update,
      photoNumber: photoNumber,
      photoCount: photoCount,
      photoNumberCallback: (int photoNumberCallback) {
        setState(() {
          photoNumber = photoNumberCallback;
          detail = true;
        });
      },
//      callback: (String decision) {
//        setState(() {
//          buttonDecision = decision;
//          detail = false;
//          buildUnDetailFirst = true;
//          print('buttonDecision: $buttonDecision');
//          getDistance(widget.profIndex.currentProf.searchUser.location);
//        });
//      },
      detailCallback: (bool detailCallBack) {
        if (detailCallBack == false) {
          setState(() {
            detail = false;
          });
        }
      },
    );
  }

  Widget _profDetail4() {
    return ProfDetail4(
      key: _frontProfKey,
      distanceFront: 0,
      currentUser: widget._currentUser,
      searchUser: widget._currentUser,
//      swipeDecision: widget.profIndex.currentProf.swipeDecision,
//      region: decisionIndicator,
      isDraggable: false,
//      update: widget.update,
      photoNumber: photoNumber,
      photoCount: photoCount,
      photoNumberCallback: (int photoNumberCallback) {
        setState(() {
          photoNumber = photoNumberCallback;
          detail = true;
        });
      },
//      callback: (String decision) {
//        setState(() {
//          buttonDecision = decision;
//          detail = false;
//          buildUnDetailFirst = true;
//          print('buttonDecision: $buttonDecision');
//          getDistance(widget.profIndex.currentProf.searchUser.location);
//        });
//      },
      detailCallback: (bool detailCallBack) {
        if (detailCallBack == false) {
          setState(() {
            detail = false;
          });
        }
      },
    );
  }

  Widget _profDetail5() {
    return ProfDetail5(
      key: _frontProfKey,
      distanceFront: 0,
      currentUser: widget._currentUser,
      searchUser: widget._currentUser,
//      swipeDecision: widget.profIndex.currentProf.swipeDecision,
//      region: decisionIndicator,
      isDraggable: false,
      photoNumber: photoNumber,
      photoCount: photoCount,
      photoNumberCallback: (int photoNumberCallback) {
        setState(() {
          photoNumber = photoNumberCallback;
          detail = true;
          print('photoNumberNext: $photoNumber');
        });
      },
//      callback: (String decision) {
//        setState(() {
//          buttonDecision = decision;
//          detail = false;
//          buildUnDetailFirst = true;
//          print('buttonDecision: $buttonDecision');
//          getDistance(widget.profIndex.currentProf.searchUser.location);
//        });
//      },
      detailCallback: (bool detailCallBack) {
        if (detailCallBack == false) {
          setState(() {
            detail = false;
          });
        }
      },
    );
  }

  Widget _profDetail6() {
    return ProfDetail6(
      key: _frontProfKey,
      distanceFront: 0,
      currentUser: widget._currentUser,
      searchUser: widget._currentUser,
//      swipeDecision: widget.profIndex.currentProf.swipeDecision,
//      region: decisionIndicator,
      isDraggable: false,
//      update: widget.update,
      photoNumber: photoNumber,
      photoCount: photoCount,
      photoNumberCallback: (int photoNumberCallback) {
        setState(() {
          photoNumber = photoNumberCallback;
          detail = true;
          print('photoNumberNext: $photoNumber');
        });
      },
//      callback: (String decision) {
//        setState(() {
//          buttonDecision = decision;
//          detail = false;
//          buildUnDetailFirst = true;
//          print('buttonDecision: $buttonDecision');
//          getDistance(widget.profIndex.currentProf.searchUser.location);
//        });
//      },
      detailCallback: (bool detailCallBack) {
        if (detailCallBack == false) {
          setState(() {
            detail = false;
          });
        }
      },
    );
  }

  void _onTapUp(TapUpDetails tapUpDetails) {
    Size size = MediaQuery.of(context).size;
    if ((tapUpDetails.globalPosition.dy / size.height) > 0.65) {
      setState(() {
        detail = true;
        //widget.photoNumberCallback(
        //                                    widget.photoNumber);
        //にしてsetstatecardstackで起こせばそっちからdistanceもらえるけどdetailのロジック「くみなおさなきゃ
      });
    } else if (tapUpDetails.globalPosition.dx / size.width < 0.5) {
      if (photoNumber > 1) {
        setState(() {
          photoNumber = photoNumber - 1;
        });
      }
      //profile cardのphotoを変更　　（or profile card毎いったる
    } else {
      if (photoNumber < photoCount) {
        setState(() {
          photoNumber = photoNumber + 1;
        });
      }
    }
  }
}
