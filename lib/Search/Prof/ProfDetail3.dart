//height ok

import 'package:Keioboys/MessageTab/MatchBloc/MatchBloc.dart';
import 'package:Keioboys/Search/DecisionIndicator.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:Keioboys/FB/MatchFB.dart';
import 'package:Keioboys/FB/SearchFB.dart';
import 'package:Keioboys/Widgets/CalculateAge.dart';
import 'package:Keioboys/Widgets/ReportDialog.dart';
import 'package:Keioboys/Widgets/ReportOthersDialog.dart';
import 'package:flutter/material.dart';
import 'package:Keioboys/Search/Swipe.dart';
import 'package:Keioboys/MessageTab/Match/Decision.dart';
import 'package:Keioboys/Search/PhotoIndicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:Keioboys/consts.dart';

String uidBack;
int differenceBack;

//typedef MatchCallback = void Function(bool matchProfile);
typedef DecisionCallback = void Function(String decision);
typedef DetailCallback = void Function(bool detail);
typedef PhotoNumberCallback = void Function(int photoNumberCallback);

class ProfDetail3 extends StatefulWidget {
  final UserData currentUser;
//  final Profile profile;
  final UserData searchUser;
  final SwipeDecision swipeDecision;
  final DecisionIndicator showingDecision;
  final bool isDraggable;
  final bool update;
  final DecisionCallback callback;
  final DetailCallback detailCallback;
  final PhotoNumberCallback photoNumberCallback;
  final int photoNumber;
  final int photoCount;
  final distanceFront;
//  final MatchCallback callback;
  const ProfDetail3({
    Key key,
    this.currentUser,
    this.searchUser,
    this.swipeDecision,
    this.showingDecision,
    this.isDraggable = false,
    this.update,
    this.callback,
    this.detailCallback,
    this.photoNumberCallback,
    this.photoNumber,
    this.photoCount,
    this.distanceFront,
  }) :
//        assert(currentUser != null),
//        _currentUser = currentUser,
        super(key: key);

  @override
  _ProfDetail3State createState() => _ProfDetail3State();
}

class _ProfDetail3State extends State<ProfDetail3> {
//class _ProfileCardState extends State<ProfileCard> {
  final SearchFB _searchFB = SearchFB();
  UserData _searchUser, _currentUser;
  int distanceFront;
  bool update2;
  MatchBloc _matchBloc;
  MatchFB _matchFB = MatchFB();
  bool firstBuild;
  bool report;
  bool reportOthers;
//  int difference;

  @override
  void initState() {
    _matchBloc = MatchBloc(matchFB: _matchFB);
    firstBuild = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _searchUser = widget.searchUser;
    _currentUser = widget.currentUser;
    if (_searchUser.name != null) {
      return Container(
        height: size.height,
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
              children: <Widget>[
//                      _buildPhotosFront(), //プロフの画像
                _buildRegionIndicator(),
                _buildDecisionIndicator(),
                _buildProfileInformation(), //プロフの情報
                (report == true)
                    ? ReportDialog(
                        currentUserId: widget.currentUser.uid,
                        selectedUserId: widget.searchUser.uid,
                        reportCallback: (bool reportCallback) {
                          setState(() {
                            report = reportCallback;
                          });
                        },
                        reportOthersCallback: (bool reportOthersCallback) {
                          setState(() {
                            report = false;
                            reportOthers = reportOthersCallback;
                          });
                        },
                      )
                    : Container(),
                (reportOthers == true)
                    ? ReportOthersDialog(
                        currentUserId: widget.currentUser.uid,
                        selectedUserId: widget.searchUser.uid,
                        reportOthersCallback: (bool reportOthersCallback) {
                          setState(() {
                            reportOthers = reportOthersCallback;
                          });
                        },
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
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
    if (widget.swipeDecision == SwipeDecision.skip) {
      if (firstBuild == true) {
        Timer(Duration(milliseconds: 500), () => widget.callback('skip'));
        firstBuild = false;
      }
      return skipIndicator(size);
    } else if (widget.swipeDecision == SwipeDecision.like) {
      if (firstBuild == true) {
        Timer(Duration(milliseconds: 500), () => widget.callback('like'));
        firstBuild = false;
      }
      return likeIndicator(size);
    } else if (widget.swipeDecision == SwipeDecision.superLike) {
      if (firstBuild == true) {
        Timer(Duration(milliseconds: 500), () => widget.callback('superLike'));
        firstBuild = false;
      }
      return superLikeIndicator(size);
    } else {
      return Container(
        color: transparent,
      );
    }
  }

  Widget _buildPhotosFront() {
    Size size = MediaQuery.of(context).size;

    return (_searchUser.photo3 != null &&
            _searchUser.photo3 != '') //前の残骸でphoto=''のやつもある今度リセットする
        ? Container(
            height: size.height * 0.5,
            child: Stack(
              children: <Widget>[
                PhotoIndicator(
                  photo: _searchUser.photo3,
                  photoNumber: widget.photoNumber,
                  photoCount: widget.photoCount,
                  currentUser: widget.currentUser,
                  selectedUser: widget.searchUser,
                  fromDetail: true,
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                      splashColor: transparent,
                      highlightColor: transparent,
                      child: Container(
                        height: size.height,
                        width: size.width * 0.2,
                      ),
                      onPressed: () {
                        if (widget.photoCount == 1) {
                          widget.detailCallback(false);
                        } else if (widget.photoNumber > 1) {
                          widget.photoNumberCallback(widget.photoNumber - 1);
                        }
                      },
                    ),
                    FlatButton(
                      splashColor: transparent,
                      highlightColor: transparent,
                      child: Container(
                        height: size.height,
                        width: size.width * 0.27,
                      ),
                      onPressed: () {
                        widget.detailCallback(false);
//                        Timer(Duration(milliseconds: 500),//消して大丈夫やっけ？リセットのためやったからもういらんのか
//                            () => widget.detailCallback(''));
                      },
                    ),
                    FlatButton(
                      splashColor: transparent,
                      highlightColor: transparent,
                      child: Container(
                        height: size.height,
                        width: size.width * 0.2,
                      ),
                      onPressed: () {
                        if (widget.photoCount == 1) {
                          widget.detailCallback(false);
                        } else if (widget.photoNumber < widget.photoCount) {
                          widget.photoNumberCallback(widget.photoNumber + 1);
                        }
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.block,
                      color: white,
                      size: size.width * 0.09,
                    ),
                    onPressed: () {
                      setState(() {
                        report = true;
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        : Container(
            height: size.height * 0.5,
          );
  }

  Widget _buildProfileInformation() {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildPhotosFront(),
            Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.01,
                left: size.width * 0.05,
                right: size.width * 0.05,
                bottom: size.height * 0.03,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "${_searchUser.name} ",
                        style: TextStyle(
                          fontSize: size.width * 0.06,
                          color: black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "(${calculateAge(_searchUser.birthday)})",
                        style: TextStyle(
                          fontSize: size.width * 0.05,
                          color: black87,
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
//                      Align(
//                        alignment: Alignment.centerRight,
//                        child: GestureDetector(
//                          child: Icon(
//                            Icons.arrow_downward,
//                            color: Colors.pink,
//                            size: size.width * 0.1,
//                          ),
//                          onTap: () {
//                            widget.detailCallback(false);
//                          },
//                        ),
//                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.005,
                  ),
                  Row(
                    children: <Widget>[
                      ((_searchUser.city == 'hide' || _searchUser.city == '') &&
                              widget.distanceFront == null)
                          ? Container()
                          : Icon(
                              Icons.location_on,
                              size: size.width * 0.04,
                              color: pink,
                            ),
                      (_searchUser.city == 'hide')
                          ? Text('')
                          : Text(
                              ' ${_searchUser.city} ',
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                color: black87,
                              ),
                            ),
                      (widget.distanceFront == null)
                          ? Container()
                          : Text(
                              (widget.distanceFront / 1000).ceil().toString() +
                                  " km",
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                color: black87,
                              ),
                            )
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
                              color: pink,
                            ),
                            Text(
                              " ${_searchUser.school}",
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                color: black87,
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
                              color: pink,
                            ),
                            Text(
                              " ${_searchUser.company}",
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                color: black87,
//                                        fontWeight: FontWeight.w400
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: size.width * 0.01,
                  ),
                  (_searchUser.profile == '')
                      ? Container()
                      : Text(
//                          "ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ",
                          "${_searchUser.profile}",
                          style: TextStyle(
                            fontSize: size.width * 0.04,
                            color: black87,
                          ),
//                        maxLines: 11,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
//      },
//    );
  }
}
