//name 9文字(9.19)

import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:Keioboys/MessageTab/MatchBloc/MatchBloc.dart';
import 'package:Keioboys/MessageTab/MatchBloc/MatchEvent.dart';
import 'package:Keioboys/MessageTab/MatchBloc/MatchState.dart';
import 'package:Keioboys/Widgets/CalculateAge.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:Keioboys/FB/MatchFB.dart';
import 'package:Keioboys/MessageTab/ProfilePage.dart';
import 'package:Keioboys/Widgets/GetDistance.dart';
import 'package:Keioboys/Widgets/ShowImageFromURL.dart';
import 'package:Keioboys/Widgets/SlideRoute.dart';
import 'package:Keioboys/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Keioboys/Widgets/fake_ui.dart' if (dart.library.html) 'dart:ui'
    as ui;
import 'package:universal_html/html.dart' as html;

class MatchPage extends StatefulWidget {
  final UserData currentUser;
  MatchPage({
    this.currentUser,
  });
  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  MatchFB matchFB = MatchFB();
  MatchBloc _matchBloc;
  String urlPhoto1;

  @override
  void initState() {
    _matchBloc = MatchBloc(matchFB: matchFB);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: BlocBuilder(
          bloc: _matchBloc,
          builder: (BuildContext context, LikedAndMatchState state) {
            if (state is LoadingState) {
              _matchBloc.add(LoadMatchUserEvent(
                currentUserId: widget.currentUser.uid,
              ));
              return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(pink),
              );
            }
            if (state is LoadMatchUserState) {
              return CustomScrollView(
                slivers: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                      stream: state.matchList,
                      builder: (context, snapshot) {
                        return SliverAppBar(
//                          pinned: true,
                          title: (!snapshot.hasData)
                              ? Text('')
                              : (snapshot.data.docs.length != 0)
                                  ? Text(
                                      "新しいマッチ(${snapshot.data.docs.length.toString()})",
                                      style: TextStyle(
                                        color: pink,
                                        fontSize: size.width * 0.05,
                                      ),
                                    )
                                  : Text(''),
                          backgroundColor: white,
                        );
                      }),
                  StreamBuilder<QuerySnapshot>(
                    stream: state.matchList,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SliverToBoxAdapter(
                          child: Container(),
                        );
                      } else if (snapshot.data.docs.length != 0) {
                        final user = snapshot.data.docs;
                        return SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              void downloadURL({selectedUserId}) async {
                                Reference refPhoto1 = FirebaseStorage.instance
                                    .ref()
                                    .child('userPhotos')
                                    .child(selectedUserId)
                                    .child('photo1');
                                urlPhoto1 = await refPhoto1.getDownloadURL();
                                if (urlPhoto1 != user[index]['photo1']) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.currentUser.uid)
                                      .collection('matchList')
                                      .doc(selectedUserId)
                                      .update({'photo1': urlPhoto1});
                                }
                              }

                              downloadURL(selectedUserId: user[index].id);
                              String imageUrl;
                              if (web) {
                                imageUrl = user[index]['photo1'];
                                ui.platformViewRegistry.registerViewFactory(
                                  imageUrl,
                                  (int _) =>
                                      html.ImageElement()..src = imageUrl,
                                );
                              }
                              return Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: size.width * 0.04,
                                      right: size.width * 0.04,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              size.width * 0.15),
                                          child: Container(
                                            height: size.width * 0.3,
                                            width: size.width * 0.3,
                                            child: (web)
                                                ? HtmlElementView(
                                                    viewType: imageUrl,
                                                  )
                                                : ShowImageFromURL(
                                                    photoURL: user[index]
                                                        ['photo1'],
                                                  ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.width * 0.05,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "${user[index]['name']} (${calculateAge(user[index]['birthday'])})",
                                              style: TextStyle(
                                                fontSize: size.width * 0.04,
                                                color: black87,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            (user[index]['currentUserDecision'] ==
                                                        'superLike' ||
                                                    user[index][
                                                            'selectedUserDecision'] ==
                                                        'superLike')
                                                ? Icon(
                                                    Icons.star,
                                                    color: Colors.orangeAccent,
                                                    size: size.width * 0.055,
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      UserData selectedUser;
                                      widget.currentUser.decision =
                                          user[index]['currentUserDecision'];
                                      selectedUser =
                                          await matchFB.getUserDetails(
                                        userId: user[index].id,
                                        decision: user[index]
                                            ['selectedUserDecision'],
                                      );
//                                  selectedUser = await matchFB.getUserDetails(
//                                    userId: user[index].id,
//                                    decision: 'like',
//                                  );
//                                  User currentUser =
//                                    await matchFB.getUserDetails(widget.userId);

                                      int distance = await getDistance(
                                          selectedUser.location);
                                      Navigator.of(context).push(
                                        slideRoute(
                                          ProfilePage(
                                            currentUser: widget.currentUser,
                                            selectedUser: selectedUser,
                                            distance: distance,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                            childCount: user.length,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                        );
                      } else {
                        return SliverToBoxAdapter(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: size.height * 0.2,
                              ),
                              Center(
                                child: Text(
                                  '新しくマッチした人はいません。',
                                  style: TextStyle(
                                    fontSize: size.width * 0.04,
                                    color: black54,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  '気になる相手にLIKEを送ってみましょう。',
                                  style: TextStyle(
                                    fontSize: size.width * 0.04,
                                    color: black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            }
            return Container();
          }),
    );
  }
}
