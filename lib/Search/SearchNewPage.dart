//name 9文字(9.19)

import 'dart:ui';
import 'package:Keioboys/FB/MatchFB.dart';
import 'package:Keioboys/FB/SearchNewFB.dart';
import 'package:Keioboys/Search/SearchNewBloc/SearchNewBloc.dart';
import 'package:Keioboys/Search/SearchNewBloc/SearchNewEvent.dart';
import 'package:Keioboys/Search/SearchNewBloc/SearchNewState.dart';
import 'package:Keioboys/Widgets/CalculateAge.dart';
import 'package:Keioboys/Widgets/UserData.dart';
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

class SearchNewPage extends StatefulWidget {
  final UserData currentUser;

  SearchNewPage({
    this.currentUser,
  });

  @override
  _SearchNewPageState createState() => _SearchNewPageState();
}

class _SearchNewPageState extends State<SearchNewPage> {
  MatchFB matchFB = MatchFB();
  SearchNewFB searchNewFB = SearchNewFB();
  SearchNewBloc _SearchNewBloc;

  @override
  void initState() {
    _SearchNewBloc = SearchNewBloc(searchNewFB: searchNewFB);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: BlocBuilder(
            bloc: _SearchNewBloc,
            builder: (BuildContext context, SearchNewState state) {
              if (state is LoadingState) {
                _SearchNewBloc.add(
                  GetUserEvent(
                    interestedGender: widget.currentUser.interestedGender,
                  ),
                );
                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(pink),
                );
              }
              if (state is LoadUserListState) {
                return CustomScrollView(
                  slivers: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: state.userList,
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
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        UserData selectedUser;
                                        selectedUser =
                                            await searchNewFB.getUserDetails(
                                          userId: user[index].id,
                                        );
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
                                    '表示する人がいません。',
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
      ),
    );
  }
}
