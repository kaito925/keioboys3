//height ok

import 'package:Keioboys/MessageTab/MatchBloc/MatchBloc.dart';
import 'package:Keioboys/Search/DecisionIndicator.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:Keioboys/FB/MatchFB.dart';
import 'package:Keioboys/FB/SearchFB.dart';
import 'package:Keioboys/Widgets/CalculateAge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Keioboys/Search/Swipe.dart';
import 'package:Keioboys/MessageTab/Match/Decision.dart';
import 'package:Keioboys/Search/PhotoIndicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:Keioboys/consts.dart';

String uidBack;
int distanceBack;

//typedef MatchCallback = void Function(bool matchProfile);
//typedef DecisionCallback = void Function(String decision);

class Prof1AndBack extends StatefulWidget {
  final UserData currentUser;
//  final Profile profile;
  final UserData searchUser;
  final SwipeDecision swipeDecision;
  final DecisionIndicator showingDecision;
  final bool isDraggable;
  final bool update;
//  final DecisionCallback callback;
  final int distanceFront;
  final bool fromMyProf;
//  final MatchCallback callback;
  const Prof1AndBack({
    Key key,
    this.currentUser,
    this.searchUser,
    this.swipeDecision,
    this.showingDecision,
    this.isDraggable = true,
    this.update,
//    this.callback,
    this.distanceFront,
    this.fromMyProf,
  }) :
//        assert(currentUser != null),
//        _currentUser = currentUser,
        super(key: key);

  @override
  _Prof1AndBackState createState() => _Prof1AndBackState();
}

class _Prof1AndBackState extends State<Prof1AndBack> {
//class _ProfileCardState extends State<ProfileCard> {
  final SearchFB _searchFB = SearchFB();
  final StreamController _streamController = StreamController.broadcast();
  UserData _searchUser, _currentUser;
  int distanceFront;
  bool update2;
  MatchBloc _matchBloc;
  MatchFB _matchFB = MatchFB();
//  bool firstBuild;
  int photoCount;
//  int difference;
  bool init;

  @override
  void initState() {
    init = true;
    _matchBloc = MatchBloc(matchFB: _matchFB);
//    firstBuild = true;
    photoCount = 0;
    if (widget.searchUser.photo1 != null && widget.searchUser.photo1 != '') {
      photoCount++;
    }
    if (widget.searchUser.photo2 != null && widget.searchUser.photo2 != '') {
      photoCount++;
    }
    if (widget.searchUser.photo3 != null && widget.searchUser.photo3 != '') {
      photoCount++;
    }
    if (widget.searchUser.photo4 != null && widget.searchUser.photo4 != '') {
      photoCount++;
    }
    if (widget.searchUser.photo5 != null && widget.searchUser.photo5 != '') {
      photoCount++;
    }
    if (widget.searchUser.photo6 != null && widget.searchUser.photo6 != '') {
      photoCount++;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _searchUser = widget.searchUser;
    getDistance(_searchUser.location);
    _currentUser = widget.currentUser;
    if (_searchUser.name != null) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 5.0,
                  spreadRadius: 2.0)
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Material(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                (widget.fromMyProf == true)
                    ? _buildPhotosFront()
                    : (widget.isDraggable == false)
                        ? _buildPhotosBack()
                        : _buildPhotosFront(),
                _buildProfileInformation(), //プロフの情報
                (widget.isDraggable == false)
                    ? Container()
                    : _buildRegionIndicator(),
                (widget.isDraggable == false)
                    ? Container()
                    : _buildDecisionIndicator()
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
      // 周りに人がいなくなったとき
//            return Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Center(
//                child: Container(
//                    child: Text(
//                  'あなたの周りに新しい人はいません。',
//                  style: TextStyle(
//                    color: Colors.black87,
//                    fontWeight: FontWeight.bold,
//                    fontSize: 16.0,
//                  ),
//                )),
//              ),
//            );
    }
//          } else {
//            print('LoadUserState: else');
//            return Container();
//          }
  }

  Widget _buildRegionIndicator() {
    Size size = MediaQuery.of(context).size;
    switch (widget.showingDecision) {
      case DecisionIndicator.SkipPlace:
        return skipIndicator(size);
        break;
      case DecisionIndicator.LikePlace:
        return likeIndicator(size);
        break;
      case DecisionIndicator.SuperLikePlace:
        return superLikeIndicator(size);
        break;
      default:
        return Container(
          color: transparent,
        );
    }
  }

  Widget _buildDecisionIndicator() {
    Size size = MediaQuery.of(context).size;
//    print('firstBuild: $firstBuild');
    if (widget.swipeDecision == SwipeDecision.skip) {
//      if (firstBuild == true) {
//        Timer(Duration(milliseconds: 500), () => widget.callback('skip'));
//      _searchBloc.dispatch(NopeEvent(
//          currentUserId: widget.userId, selectedUserId: _searchUser.uid));
//        firstBuild = false;
//      }
      return skipIndicator(size);
    } else if (widget.swipeDecision == SwipeDecision.like) {
//      if (firstBuild == true) {
//        Timer(Duration(milliseconds: 500), () => widget.callback('like'));
//        firstBuild = false;
//      }
      return likeIndicator(size);
    } else if (widget.swipeDecision == SwipeDecision.superLike) {
//      if (firstBuild == true) {
//        Timer(Duration(milliseconds: 500), () => widget.callback('superLike'));
//        firstBuild = false;
//      }
      return superLikeIndicator(size);
//    }
//    else if (widget.decision == Decision.undo) {
//      print('_buildDecisionIndicator: undo');
//      if (firstBuild == true) {
//        print('sjsj');
//        Timer(Duration(milliseconds: 500), () => widget.callback('undo'));
//        firstBuild = false;
//      }
//      return _superLikeIndicator();
//      return Container();
    } else {
      return Container(
        color: transparent,
      );
    }
  }

//  Widget _nopeIndicator() {
//    Size size = MediaQuery.of(context).size;
//    // NOPEにふったときのエフェクトのNOPE
//    return Align(
//      alignment: Alignment.topRight,
//      child: Transform.rotate(
//        angle: 270.0,
//        origin: Offset(
//          size.width * 0.55,
//          size.height * 0.2,
//        ),
//
////        child: Stack(
////          children: <Widget>[
////            Container(
////              height: size.height * 0.1,
////              width: size.height * 0.26,
////              decoration: BoxDecoration(
//////                color: Colors.white38,
////                borderRadius: BorderRadius.circular(100),
////              ),
////            ),
//        child: Container(
//          height: size.height * 0.1,
//          width: size.width * 0.5,
//          margin: EdgeInsets.only(bottom: size.height * 0.15),
//          decoration: BoxDecoration(
//            border: Border.all(
//              color: Colors.blueAccent,
////              color: Colors.deepPurpleAccent,
//              width: size.width * 0.01,
////                border: Border(
////                  bottom: BorderSide(
////                    color: Colors.deepPurple,
////                    width: size.height * 0.005,
////                  ),
//            ),
//            borderRadius: BorderRadius.circular(100),
////            border: Border.all(
////              color: Colors.deepPurple,
////              width: size.height * 0.005,
////            ),
//          ),
//          child: Center(
//            child: Text(
//              "う～ん…",
//              style: TextStyle(
//                color: Colors.blueAccent,
//                fontSize: size.width * 0.09,
//                fontWeight: FontWeight.bold,
//              ),
//            ),
//          ),
////            ),
////          ],
//        ),
//      ),
//    );
//  }
//
//  Widget _likeIndicator() {
//    Size size = MediaQuery.of(context).size;
//    return Align(
//      alignment: Alignment.topLeft,
//      child: Transform.rotate(
//        angle: 270.0,
//        origin: Offset(
//          size.width * 0.55,
//          -size.height * 0.2,
//        ),
//        child: Container(
//          height: size.height * 0.1,
//          width: size.width * 0.5,
//          margin: EdgeInsets.only(bottom: size.height * 0.15),
//          decoration: BoxDecoration(
//            border: Border.all(
//              color: pink,
//              width: size.width * 0.01,
//            ),
//            borderRadius: BorderRadius.circular(100),
//          ),
//          child: Center(
//            child: Text(
//              "いいね！",
//              style: TextStyle(
//                color: pink,
//                fontSize: size.width * 0.09,
//                fontWeight: FontWeight.bold,
//              ),
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget _superLikeIndicator() {
//    Size size = MediaQuery.of(context).size;
//    return Align(
//      alignment: Alignment.bottomCenter,
//      child: Transform.rotate(
//        angle: 270.0,
//        origin: Offset(
//          0,
//          -size.height * 0.15,
//        ),
//        child: Container(
//          height: size.height * 0.15,
//          width: size.width * 0.7,
//          margin: EdgeInsets.only(bottom: size.height * 0.2),
//          decoration: BoxDecoration(
//            border: Border.all(
//              color: Colors.orangeAccent,
//              width: size.width * 0.01,
//            ),
//            borderRadius: BorderRadius.circular(100),
//          ),
//          child: Center(
//            child: Text(
//              "超いいね！！",
//              textAlign: TextAlign.center,
//              style: TextStyle(
//                color: Colors.orangeAccent,
//                fontSize: size.width * 0.09,
//                fontWeight: FontWeight.bold,
//              ),
//            ),
//          ),
//        ),
//      ),
//    );
//  }

  Widget _buildPhotosFront() {
    return (_searchUser.photo1 != null &&
            _searchUser.photo1 != '') //前の残骸でphoto=''のやつもある今度リセットする
        ? PhotoIndicator(
            photo: _searchUser.photo1,
            photoNumber: 1,
            photoCount: photoCount,
          )
        : Container();
  }

  Widget _buildPhotosBack() {
    return (_searchUser.photo1 != null &&
            _searchUser.photo1 != '') //前の残骸でphoto=''のやつもある今度リセットする
        ? PhotoIndicator(
            photo: _searchUser.photo1,
            photoNumber: 1,
            photoCount: photoCount,
          )
        : Container();
  } //新規でつくるか壊せないか

  Widget _buildProfileInformation() {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        return Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            height: size.height * 0.32,
            width: size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  transparent,
                  black.withAlpha(170),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: EdgeInsets.only(
              left: size.width * 0.05,
              right: size.width * 0.05,
              bottom: size.height * 0.03,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "${_searchUser.name} ",
                      style: TextStyle(
                        fontSize: size.width * 0.06,
                        color: white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "(${calculateAge(_searchUser.birthday)})",
                      style: TextStyle(
                        fontSize: size.width * 0.05,
                        color: white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.025,
                    ),
                    (_searchUser.decision == 'superLike')
                        ? Icon(
                            Icons.star,
                            color: Colors.orangeAccent,
                            size: size.width * 0.1,
                          )
                        : Container(),
                  ],
                ),

                Row(
                  children: <Widget>[
                    (_searchUser.city == 'hide' || _searchUser.city == '')
                        ? (widget.isDraggable != false)
                            ? (widget.distanceFront != null)
                                ? Icon(
                                    Icons.location_on,
                                    size: size.width * 0.04,
                                    color: white,
                                  )
                                : (distanceFront == null)
                                    ? (snapshot.data == null)
                                        ? Container()
                                        : Icon(
                                            Icons.location_on,
                                            size: size.width * 0.04,
                                            color: white,
                                          )
                                    : Icon(
                                        Icons.location_on,
                                        size: size.width * 0.04,
                                        color: white,
                                      )
                            : (distanceBack == null)
                                ? (widget.fromMyProf == true)
                                    ? Icon(
                                        Icons.location_on,
                                        size: size.width * 0.04,
                                        color: white,
                                      )
                                    : Container()
                                : Icon(
                                    Icons.location_on,
                                    size: size.width * 0.04,
                                    color: white,
                                  )
                        : Icon(
                            Icons.location_on,
                            size: size.width * 0.04,
                            color: white,
                          ),
                    (_searchUser.city == 'hide')
                        ? Text('')
                        : Text(
                            ' ${_searchUser.city} ',
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              color: white,
                            ),
                          ),
                    (widget.fromMyProf == true)
                        ? Text(
                            "0 km",
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              color: white,
                            ),
                          )
                        : (widget.isDraggable != false)
                            ? (widget.distanceFront != null)
                                ? Text(
                                    (widget.distanceFront / 1000)
                                            .ceil()
                                            .toString() +
                                        " km",
                                    style: TextStyle(
                                      fontSize: size.width * 0.04,
                                      color: white,
                                    ),
                                  )
                                : (distanceFront == null)
                                    ? (snapshot.data == null)
                                        ? Container()
                                        : Text(
                                            (snapshot.data / 1000)
                                                    .ceil()
                                                    .toString() +
                                                " km",
                                            style: TextStyle(
                                              fontSize: size.width * 0.04,
                                              color: white,
                                            ),
                                          )
                                    : Text(
//                                (snapshot.data / 1000).floor().toString() +
//                                    " km",
//                          (difference / 1000).floor().toString() + " km",
                                        (distanceFront / 1000)
                                                .ceil()
                                                .toString() +
                                            " km",
                                        style: TextStyle(
                                          fontSize: size.width * 0.04,
                                          color: white,
                                        ),
                                      )
                            : (distanceBack == null)
                                ? Container()
                                : Text(
//                                (snapshot.data / 1000).floor().toString() +
//                                    " km",
//                          (difference / 1000).floor().toString() + " km",
                                    (distanceBack / 1000).ceil().toString() +
                                        " km",
                                    style: TextStyle(
                                      fontSize: size.width * 0.04,
                                      color: white,
                                    ),
                                  ),
                  ],
                ),

                (_searchUser.school == '')
                    ? Container()
                    : Row(
                        children: <Widget>[
                          Icon(
//                                    FontAwesomeIcons.school,
                            Icons.school,
                            size: size.width * 0.04,
                            color: white,
                          ),
                          Text(
//                                "ああああああああああああああああああ",
                            " ${_searchUser.school}",
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              color: white,
                            ),
                          ),
                        ],
                      ),
                (_searchUser.company == '')
                    ? Container()
                    : Row(
                        children: <Widget>[
                          Icon(
                            Icons.work,
                            size: size.width * 0.04,
                            color: white,
                          ),
                          Text(
                            "${_searchUser.company}",
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              color: white,
//                                        fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
//                        (_searchUser.address == '')
//                            ? Container()
//                            : new Text(
//                                "${_searchUser.address}",
//                                style: TextStyle(
//                                    fontSize: 14.0,
//                                    color: white,
//                                    fontWeight: FontWeight.bold),
//                              ),
                (_searchUser.profile == '')
                    ? Container()
                    : Text(
//                                "あああああああああああああああああああああああああああああああああああああああああああ",
                        "${_searchUser.profile}",
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

//                        (difference == null)
//                            ? Container()
//                            : new Text(
////                                (snapshot.data / 1000).floor().toString() +
////                                    " km",
////                          (difference / 1000).floor().toString() + " km",
//                                (difference / 1000).floor().toString() + " km",
//                                style: TextStyle(
//                                    fontSize: 14.0,
//                                    color: Colors.white,
//                                    fontWeight: FontWeight.w400),
//                              )
//                        (snapshot.data == null)
//                  (difference == null)
              ],
            ),
          ),
        );
      },
    );
  }

  getDistance(GeoPoint userLocation) async {
    if (widget.isDraggable != false && uidBack == _searchUser.uid) {
      distanceFront = distanceBack;
//      _streamController.add(distanceFront);
    } else if (
//    widget.isDraggable != false &&
//            widget.update == true &&
//            update2 != false ||
        init == true) {
//    } else if (widget.isDraggable != false && uidBack == null) {
      init = false;
      Position position;
      double location;
      if (android || ios) {
        position = await Geolocator.getLastKnownPosition();
      } else if (web) {
        position = await Geolocator.getCurrentPosition();
      }
      if (userLocation != null) {
        location = Geolocator.distanceBetween(
          userLocation.latitude,
          userLocation.longitude,
          position.latitude,
          position.longitude,
        );
        distanceFront = location.toInt();
      }

      setState(() {
        _streamController.add(distanceFront);
      });
      update2 = false;
    } else if (widget.isDraggable == false &&
        uidBack != _searchUser.uid &&
        userLocation == null) {
      await Future.delayed(Duration(milliseconds: 10));
      uidBack = _searchUser.uid;
      distanceBack = null;
    } else if (widget.isDraggable == false &&
            uidBack != _searchUser.uid &&
            userLocation != null
        //&& uidBack != null
        ) {
//      differenceFront = differenceBack;
      Position position;
      double location;
      if (android || ios) {
        position = await Geolocator.getLastKnownPosition();
      } else if (web) {
        position = await Geolocator.getCurrentPosition();
      }
      if (userLocation != null) {
        location = Geolocator.distanceBetween(
          userLocation.latitude,
          userLocation.longitude,
          position.latitude,
          position.longitude,
        );
      }
      distanceBack = location.toInt();
      uidBack = _searchUser.uid;
    } else {}
  }
}
