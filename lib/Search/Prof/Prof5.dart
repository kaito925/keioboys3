//height ok

import 'package:Keioboys/MessageTab/MatchBloc/MatchBloc.dart';
import 'package:Keioboys/Search/DecisionIndicator.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:Keioboys/FB/MatchFB.dart';
import 'package:Keioboys/FB/SearchFB.dart';
import 'package:Keioboys/Widgets/CalculateAge.dart';
import 'package:flutter/material.dart';
import 'package:Keioboys/Search/Swipe.dart';
import 'package:Keioboys/MessageTab/Match/Decision.dart';
import 'package:Keioboys/Search/PhotoIndicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:Keioboys/consts.dart';

String uidBack;
int differenceBack;

//typedef DecisionCallback = void Function(String decision);

class Prof5 extends StatefulWidget {
  final UserData currentUser;
  final UserData searchUser;
  final SwipeDecision swipeDecision;
  final DecisionIndicator showingDecision;
  final bool isDraggable;
  final bool update;
//  final DecisionCallback callback;
  final int distanceFront;
  const Prof5({
    Key key,
    this.currentUser,
    this.searchUser,
    this.swipeDecision,
    this.showingDecision,
    this.isDraggable = true,
    this.update,
//    this.callback,
    this.distanceFront,
  }) : super(key: key);

  @override
  _Prof5State createState() => _Prof5State();
}

class _Prof5State extends State<Prof5> {
  final SearchFB _searchFB = SearchFB();
  UserData _searchUser, _currentUser;
  int differenceFront;
  bool update2;
  MatchBloc _matchBloc;
  MatchFB _matchFB = MatchFB();
//  bool firstBuild;
  int photoCount;

  @override
  void initState() {
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
    _searchUser = widget.searchUser; //サーチで出てくる一番前の人

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
                _buildPhotosFront(),
                _buildProfileInformation(), //プロフの情報
                _buildRegionIndicator(),
                _buildDecisionIndicator()
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
//    print('firstBuild: $firstBuild');
    if (widget.swipeDecision == SwipeDecision.skip) {
//      if (firstBuild == true) {
//        Timer(Duration(milliseconds: 500), () => widget.callback('skip'));
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
    } else {
      return Container(
        color: transparent,
      );
    }
  }

  Widget _buildPhotosFront() {
    return (_searchUser.photo5 != null &&
            _searchUser.photo5 != '') //前の残骸でphoto=''のやつもある今度リセットする
        ? PhotoIndicator(
            photo: _searchUser.photo5,
            photoNumber: 5,
            photoCount: photoCount,
          )
        : Container();
  }

  Widget _buildProfileInformation() {
    Size size = MediaQuery.of(context).size;
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
//                              "あいうえおかきく",
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
                ((_searchUser.city == 'hide' || _searchUser.city == '') &&
                        widget.distanceFront == null)
                    ? Container()
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
                (widget.distanceFront == null)
                    ? Container()
                    : Text(
                        (widget.distanceFront / 1000).ceil().toString() + " km",
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: white,
                        ),
                      )
              ],
            ),
            (_searchUser.school == '')
                ? Container()
                : Row(
                    children: <Widget>[
                      Icon(
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
                        ),
                      ),
                    ],
                  ),
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
          ],
        ),
      ),
    );
  }
}
