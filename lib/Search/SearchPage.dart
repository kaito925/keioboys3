//著作ok
//height ok

import 'dart:async';
import 'package:Keioboys/MessageTab/Match/Decision.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:Keioboys/FB/SearchFB.dart';
import 'package:Keioboys/Search/ProfList.dart';
import 'package:Keioboys/MessageTab/Match/ProfIndex.dart';
import 'package:Keioboys/Widgets/CircleButton.dart';
import 'package:flutter/material.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:Keioboys/consts.dart';

class SearchPage extends StatefulWidget {
  final UserData currentUser;
  final UserFB userFB;
//  final String matchPhoto;
//  final String matchName;

  SearchPage({
    this.currentUser,
    this.userFB,
//    this.matchPhoto,
//    this.matchName,
  });
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ProfIndex profIndex;
  final SearchFB _searchFB = SearchFB();
  final StreamController _streamController = StreamController.broadcast();
  bool loading;
//  bool update;
  List searchUserList;

//  int count;

  @override
  void initState() {
    loading = false;
    updateSearchUserList();
//    update = true;
//    count = 0;
//    print('AAcount: $count');
    super.initState();
  }

  Future updateSearchUserList() async {
    print('updateSearchUserList');
    setState(() {
      loading = true;
    });
    searchUserList = await _searchFB.getSearchUserList(widget.currentUser);
    profIndex = ProfIndex(
      decisions: searchUserList.map((searchUser) {
        return Decision(selectedUser: searchUser);
      }).toList(),
    );
//    for (var searchUser in searchUserList) {
//      print('uidList: ${searchUser.uid}');
//    }
    setState(() {
      loading = false;
    });
    _streamController.add(searchUserList);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            return (snapshot.data.toString() == '[]' && loading != true)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '新しい人は見つかりませんでした。',
                          style: TextStyle(
                            color: black87,
                            fontSize: size.width * 0.045,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        GestureDetector(
                          child: Container(
                            width: size.width * 0.7,
                            height: size.width * 0.1,
                            decoration: BoxDecoration(
                              color: pink,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Text(
                                '更新する',
                                style: TextStyle(
                                  color: white,
                                  fontSize: size.width * 0.05,
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            updateSearchUserList();
                          },
                        ),
                      ],
                    ),
                  )
                : (profIndex == null || loading == true)
                    ? Container(
                        //読み込み待ち
                        child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(pink),
                          ),
                        ),
                      )
                    : //(searchUserLis
                    ProfList(
//                          key: GlobalKey(),
                        profIndex: profIndex,
                        currentUser: widget.currentUser,
                        searchUserListLength: searchUserList.length,
                        userFB: widget.userFB,
                        searchFB: _searchFB,
                        updateCallback: (bool update) {
                          if (update == true) {
                            updateSearchUserList();
                          }
                        },
                      );
          },
        ),
      ), //: Container();
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
//              circleButton(
//                icon: Icons.settings_backup_restore,
//                color: Colors.orange,
//                size: size.width * 0.17,
//                onPressed: () {
////                  if (matchEngine != null) {
////                    Timer(Duration(milliseconds: 100),
////                            () => matchEngine.currentMatch.undo());
////                  }
//                },
//              ),
              circleButton(
                icon: Icons.clear,
                color: Colors.blueAccent,
                size: size.width * 0.17,
                onPressed: () {
                  if (profIndex != null) {
                    Timer(
                      Duration(milliseconds: 100),
                      () => profIndex.currentProf.buttonSkip(),
//                      () => profIndex.currentProf.skip(),
                    );
                  }
                },
              ),
              circleButton(
                icon: Icons.star,
                color: Colors.orangeAccent,
                size: size.width * 0.17,
                onPressed: () {
                  if (profIndex != null) {
                    Timer(
                      Duration(milliseconds: 100),
                      () => profIndex.currentProf.buttonSuperLike(),
//                      () => profIndex.currentProf.superLike(),
                    );
                  }
                },
              ),
              circleButton(
                icon: Icons.favorite,
                color: Colors.pinkAccent,
                size: size.width * 0.17,
                onPressed: () {
                  if (profIndex != null) {
                    Timer(
                      Duration(milliseconds: 100),
                      () => profIndex.currentProf.buttonLike(),
//                      () => profIndex.currentProf.like(),
                    );
                  }
                },
              ),

//              circleButton(
//                icon: FontAwesomeIcons.bolt,
////                image: lightening,
//                color: Colors.purpleAccent,
//                size: size.width * 0.17,
//                onPressed: () {
////                  if (matchEngine != null) {
////                  Timer(Duration(milliseconds: 100),
////                      () => matchEngine.currentMatch.boost(),);
////                  }
//                },
//              ),
            ],
          ),
        ),
      ),
    );
  }
}
