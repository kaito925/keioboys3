//著作ok

import 'dart:async';
import 'package:Keioboys/FB/MatchFB.dart';
import 'package:Keioboys/MessageTab/MessageBloc/Bloc.dart';
import 'package:Keioboys/MessageTab/Message.dart';
import 'package:Keioboys/Widgets/SaveValueLocal.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:Keioboys/FB/MessageFB.dart';
import 'package:Keioboys/MessageTab/MessageBubble.dart';
import 'package:Keioboys/Widgets/GetDistance.dart';
import 'package:Keioboys/Widgets/ShowImageFromURL.dart';
import 'package:Keioboys/MessageTab/SendMessageField.dart';
import 'package:Keioboys/Widgets/SlideRoute.dart';
import 'package:Keioboys/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ProfilePage.dart';
import 'dart:math' as math;
import 'package:Keioboys/Widgets/fake_ui.dart' if (dart.library.html) 'dart:ui'
    as ui;
import 'package:universal_html/html.dart' as html;

class MessagePage extends StatefulWidget {
  final UserData currentUser;
  final bool isFirstMessage;
  final bool firstMessageFromMe;
  final String selectedUserId;
  final String selectedUserName;
  final String selectedUserPhoto1;
  final String selectedUserDecision;

  MessagePage({
    this.currentUser,
    this.isFirstMessage,
    this.firstMessageFromMe,
    this.selectedUserId,
    this.selectedUserName,
    this.selectedUserPhoto1,
    this.selectedUserDecision,
  });

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _textController = TextEditingController();
  //  TextEditingController _messageTextController;
//  FocusNode _focusNode;
//  ScrollController _scrollController;
  MessageFB _messageFB = MessageFB();
  MatchFB matchFB = MatchFB();
  MessageBloc _messageBloc;
  Key orderKey;
  Size size;
//  bool _isShow;
//  Timestamp lastMessageTimeStamp;
  int distance;
  int lastHasPendingWritesFalseMessageIndex;
  bool first;
  List dateSpot = [
    ['東京ディズニーランド', 'https://www.tokyodisneyresort.jp/tdl/'],
    ['東京ディズニーシー', 'https://www.tokyodisneyresort.jp/tds/'],
    ['恵比寿ガーデンプレイス', 'https://gardenplace.jp/'],
    ['明治神宮', 'https://www.meijijingu.or.jp/'],
    ['新宿御苑', 'https://www.env.go.jp/garden/shinjukugyoen/'],
    ['ルミネtheよしもと', 'http://www.yoshimoto.co.jp/lumine/'],
    ['コニカミノルタプラネタリウム“満天”', 'https://planetarium.konicaminolta.jp/'],
    ['サンシャイン水族館', 'https://sunshinecity.jp/'],
    ['SKY CIRCUS サンシャイン60展望台', 'https://sunshinecity.jp/'],
    ['東京ドームシティ アトラクションズ', 'https://at-raku.com/'],
    ['国立新美術館', 'https://www.nact.jp/'],
    ['東京タワー', 'https://www.tokyotower.co.jp/'],
    ['芝公園', 'https://www.tokyo-park.or.jp/park/format/index001.html'],
    ['アクアパーク品川', 'http://www.aqua-park.jp/aqua/index.html'],
    ['日本科学未来館', 'https://www.miraikan.jst.go.jp/'],
    ['大江戸温泉物語', 'https://daiba.ooedoonsen.jp/'],
    ['葛西臨海水族園', 'https://www.tokyo-zoo.net/zoo/kasai/'],
    ['東京スカイツリー', 'http://www.tokyo-skytree.jp/'],
    ['すみだ水族館', 'https://www.sumida-aquarium.com/index.html'],
    ['浅草寺', 'https://www.senso-ji.jp/'],
    ['東京国立博物館', 'https://www.tnm.jp/'],
    ['アメ横', 'http://www.ameyoko.net/'],
    ['チームラボボーダレス', 'https://borderless.teamlab.art/jp/'],
    ['チームラボプラネッツ', 'https://planets.teamlab.art/tokyo/jp/'],
    ['国立科学博物館', 'https://www.kahaku.go.jp/'],
  ];

  @override
  void initState() {
    void getValueLocalHere() async {
      lastHasPendingWritesFalseMessageIndex = await getValueLocal(
          path:
              'messagePage/lastHasPendingWritesFalseMessageIndex/${widget.selectedUserId}');
    }

    getValueLocalHere();

//    _scrollController = ScrollController();
//    _scrollController.addListener(_scrollListener);
//    _scrollController.addListener(() {
//      final maxScrollExtent = _scrollController.position.maxScrollExtent;
//      final currentPosition = _scrollController.position.pixels;
//      if (maxScrollExtent > 0 && (maxScrollExtent - 20.0) <= currentPosition) {
//        _addContents();
//      }
//    });

    _messageBloc = MessageBloc(messageFB: _messageFB);
//    _focusNode = FocusNode();
//    _messageTextController = TextEditingController();
    first = true;
    super.initState();
  }

//  void _scrollListener() {
//    double positionRate =
//        _scrollController.offset / _scrollController.position.maxScrollExtent;

//    if (_scrollController.offset ==
//        _scrollController.position.maxScrollExtent) {
//      print('888888888: 8');
//      _messagingBloc.dispatch(MessageStreamEvent(
//          currentUserId: widget.currentUser.uid,
//          selectedUserId: widget.selectedUser.uid,
//          lastMessageTimeStamp:
//              lastMessageTimeStamp)); //navigatorで新しいページにしてしまう？offset==0&&もどるときスワイプダウン検出してpopしたい。

//    }
//  }

  @override
  void dispose() {
    _textController.dispose();
//    _messageTextController.dispose();
//    _scrollController.dispose();
//    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl;
    if (web) {
      imageUrl = widget.selectedUserPhoto1;
      ui.platformViewRegistry.registerViewFactory(
        imageUrl,
        (int _) => html.ImageElement()..src = imageUrl,
      );
    }
    size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        _messageFB.updateLastOpenedTime(
          currentUserId: widget.currentUser.uid,
          selectedUserId: widget.selectedUserId,
        );
        return Future.value(false);
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 80,
              brightness: Brightness.light,
              iconTheme: IconThemeData(
                color: pink,
              ),
              backgroundColor: white,
//                elevation: 0,
              titleSpacing: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      UserData selectedUser;
                      selectedUser = await matchFB.getUserDetails(
                        userId: widget.selectedUserId,
                        decision: widget.selectedUserDecision,
                      );
                      int distance = await getDistance(selectedUser.location);
                      Navigator.of(context).push(
                        slideRoute(
                          ProfilePage(
                            currentUser: widget.currentUser,
                            selectedUser: selectedUser,
                            distance: distance,
                            fromMessage: true,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(size.height * 0.025),
                      child: Stack(
                        children: [
                          Container(
                            height: size.height * 0.05,
                            width: size.height * 0.05,
                            child: (web)
                                ? HtmlElementView(
                                    viewType: imageUrl,
                                  )
                                : ShowImageFromURL(
                                    photoURL: widget.selectedUserPhoto1,
                                  ),
                          ),
                          Container(
                            height: size.height * 0.05,
                            width: size.height * 0.05,
                            color: transparent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text(
                          widget.selectedUserName,
                          style: TextStyle(
                            color: black87,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.025,
                        ),
                        (widget.currentUser.decision == 'superLike' ||
                                widget.selectedUserDecision == 'superLike')
                            ? Icon(
                                Icons.star,
                                color: Colors.orangeAccent,
                                size: size.width * 0.08,
                              )
                            : Container(),
                      ],
                    ),
                  ),
//                  IconButton(
//                      icon: Icon(
//                        Icons.wc,
//                        color: pink,
//                        size: size.height * 0.035,
//                      ),
//                      onPressed: () async {
//                        int randomNumber = math.Random().nextInt(25);
//                        await _messageFB.sendMessage(
//                          message: Message(
//                            text:
//                                '【Starsおすすめデートスポット】\n\n一緒に${dateSpot[randomNumber][0]}へ行きませんか？\n\n${dateSpot[randomNumber][1]}',
//                            currentUserId: widget.currentUser.uid,
////                              senderName: widget.currentUser.name,
//                            selectedUserId: widget.selectedUserId,
////                              photo: null,
//                            currentUserDecision: widget.currentUser.decision,
//                            selectedUserDecision: widget.selectedUserDecision,
//                          ),
//                          isFirstMessage:
//                              (first == true) ? widget.isFirstMessage : false,
//                          currentUserName: widget.currentUser.name,
//                          currentUserPhoto1: widget.currentUser.photo1,
//                          selectedUserName: widget.selectedUserName,
//                          selectedUserPhoto1: widget.selectedUserPhoto1,
//                        );
//                        first = false;
//                      }),
                  IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: pink,
                      size: size.height * 0.035,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              content: Container(
                                width: size.width * 0.9,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    FlatButton(
                                      child: Container(
                                        height: size.height * 0.05,
                                        width: size.width * 0.9,
                                        child: Center(
                                          child: Text(
                                            'ブロック',
                                            style: TextStyle(
                                              color: black87,
                                              fontSize: size.width * 0.05,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (_) {
                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return AlertDialog(
                                                  content: Container(
                                                    width: size.width * 0.9,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.02),
                                                        Text(
                                                          "ブロックしてよろしいですか？",
                                                          style: TextStyle(
                                                            color: black87,
                                                            fontSize:
                                                                size.width *
                                                                    0.05,
                                                          ),
                                                        ),
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
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        }),
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
                                                        Navigator.pop(context);
                                                        _messageFB
                                                            .deleteMessage(
                                                          currentUserId: widget
                                                              .currentUser.uid,
                                                          selectedUserId: widget
                                                              .selectedUserId,
                                                        );
                                                      },
                                                    ),
                                                  ],
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
                                        width: size.width * 0.9,
                                        child: Center(
                                          child: Text(
                                            'このユーザーを報告',
                                            style: TextStyle(
                                              color: black87,
                                              fontSize: size.width * 0.05,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (_) {
                                            return StatefulBuilder(
                                                builder: (context, setState) {
                                              return AlertDialog(
                                                title: Text('ユーザーを報告'),
                                                content: Container(
                                                  width: size.width * 0.9,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
//                                                  crossAxisAlignment:
//                                                      CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.01,
                                                      ),
                                                      Divider(
                                                        color: black87,
                                                      ),
                                                      FlatButton(
                                                        child: Container(
                                                          height: size.height *
                                                              0.05,
                                                          width:
                                                              size.width * 0.9,
                                                          child: Center(
                                                            child: Text(
                                                              '不適切な写真',
                                                              style: TextStyle(
                                                                color: black87,
                                                                fontSize:
                                                                    size.width *
                                                                        0.05,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          _messageBloc.add(
                                                            SendReportEvent(
                                                                report: Message(
                                                                  currentUserId:
                                                                      widget
                                                                          .currentUser
                                                                          .uid,
                                                                  selectedUserId:
                                                                      widget
                                                                          .selectedUserId,
                                                                ),
                                                                reason:
                                                                    'photo'),
                                                          );
                                                          _textController
                                                              .clearComposing();
                                                          Navigator.pop(
                                                              context);
                                                          Flushbar(
                                                            message:
                                                                "ユーザーを報告しました。",
                                                            backgroundColor:
                                                                pink,
                                                            duration: Duration(
                                                                seconds: 3),
                                                          )..show(context);
                                                        },
                                                      ),
                                                      Divider(
                                                        color: black87,
                                                      ),
                                                      FlatButton(
                                                        child: Container(
                                                          height: size.height *
                                                              0.05,
                                                          width:
                                                              size.width * 0.9,
                                                          child: Center(
                                                            child: Text(
                                                              '不適切な自己紹介',
                                                              style: TextStyle(
                                                                color: black87,
                                                                fontSize:
                                                                    size.width *
                                                                        0.05,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          _messageBloc.add(
                                                            SendReportEvent(
                                                                report: Message(
                                                                  currentUserId:
                                                                      widget
                                                                          .currentUser
                                                                          .uid,
                                                                  selectedUserId:
                                                                      widget
                                                                          .selectedUserId,
                                                                ),
                                                                reason: 'bio'),
                                                          );
                                                          _textController
                                                              .clear();
                                                          Navigator.pop(
                                                              context);
                                                          Flushbar(
                                                            message:
                                                                "ユーザーを報告しました。",
                                                            backgroundColor:
                                                                pink,
                                                            duration: Duration(
                                                                seconds: 3),
                                                          )..show(context);
                                                        },
                                                      ),
                                                      Divider(
                                                        color: black87,
                                                      ),
                                                      FlatButton(
                                                        child: Container(
                                                          height: size.height *
                                                              0.05,
                                                          width:
                                                              size.width * 0.9,
                                                          child: Center(
                                                            child: Text(
                                                              '不適切なメッセージ',
                                                              style: TextStyle(
                                                                color: black87,
                                                                fontSize:
                                                                    size.width *
                                                                        0.05,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          _messageBloc.add(
                                                            SendReportEvent(
                                                                report: Message(
                                                                  currentUserId:
                                                                      widget
                                                                          .currentUser
                                                                          .uid,
                                                                  selectedUserId:
                                                                      widget
                                                                          .selectedUserId,
                                                                ),
                                                                reason:
                                                                    'message'),
                                                          );
                                                          _textController
                                                              .clear();
                                                          Navigator.pop(
                                                              context);
                                                          Flushbar(
                                                            message:
                                                                "ユーザーを報告しました。",
                                                            backgroundColor:
                                                                pink,
                                                            duration: Duration(
                                                                seconds: 3),
                                                          )..show(context);
                                                        },
                                                      ),
                                                      Divider(
                                                        color: black87,
                                                      ),
                                                      FlatButton(
                                                        child: Container(
                                                          height: size.height *
                                                              0.05,
                                                          width:
                                                              size.width * 0.9,
                                                          child: Center(
                                                            child: Text(
                                                              'その他の理由',
                                                              style: TextStyle(
                                                                color: black87,
                                                                fontSize:
                                                                    size.width *
                                                                        0.05,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          showDialog(
                                                            context: context,
                                                            builder: (_) {
                                                              return StatefulBuilder(
                                                                  builder: (context,
                                                                      setState) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      'ユーザーを報告'),
                                                                  content:
                                                                      SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    child:
                                                                        Container(
                                                                      width: size
                                                                              .width *
                                                                          0.9,
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: <
                                                                            Widget>[
                                                                          SizedBox(
                                                                            height:
                                                                                size.height * 0.02,
                                                                          ),
                                                                          TextField(
                                                                            controller:
                                                                                _textController,
                                                                            cursorColor:
                                                                                pink,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: black87,
                                                                                  width: size.height * 0.001,
                                                                                ),
                                                                              ),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(
                                                                                  color: black87,
                                                                                  width: size.height * 0.001,
                                                                                ),
                                                                              ),
                                                                              labelText: '報告の理由',
                                                                              labelStyle: TextStyle(
                                                                                color: black87,
                                                                              ),
                                                                            ),
                                                                            autofocus:
                                                                                true,
                                                                            minLines:
                                                                                5,
                                                                            maxLines:
                                                                                null,
                                                                            maxLengthEnforcement:
                                                                                MaxLengthEnforcement.none,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  actions: <
                                                                      Widget>[
                                                                    FlatButton(
                                                                      splashColor:
                                                                          lightGrey,
                                                                      child:
                                                                          Text(
                                                                        "キャンセル",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              black87,
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                    FlatButton(
                                                                      splashColor:
                                                                          lightGrey,
                                                                      child:
                                                                          Text(
                                                                        "送信",
                                                                        style: TextStyle(
                                                                            color:
                                                                                pink),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        _messageBloc
                                                                            .add(
                                                                          SendReportEvent(
                                                                              report: Message(
                                                                                text: _textController.text,
                                                                                currentUserId: widget.currentUser.uid,
                                                                                selectedUserId: widget.selectedUserId,
                                                                              ),
                                                                              reason: 'others'),
                                                                        );
                                                                        _textController
                                                                            .clear();
                                                                        Navigator.pop(
                                                                            context);
                                                                        Flushbar(
                                                                          message:
                                                                              "ユーザーを報告しました。",
                                                                          backgroundColor:
                                                                              pink,
                                                                          duration:
                                                                              Duration(seconds: 3),
                                                                        )..show(
                                                                            context);
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              });
                                                            },
                                                          );
                                                        },
                                                      ),
                                                      Divider(
                                                        color: black87,
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.02,
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        child: FlatButton(
                                                          child: Text(
                                                            "キャンセル",
                                                            style: TextStyle(
                                                              color: black87,
                                                            ),
                                                            textAlign:
                                                                TextAlign.end,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            body: BlocBuilder(
              bloc: _messageBloc,
              builder: (BuildContext context, MessageState state) {
                if (state is MessageInitialState) {
                  _messageBloc.add(MessageStreamEvent(
                    currentUserId: widget.currentUser.uid,
                    selectedUserId: widget.selectedUserId,
                  ));
                }
                if (state is MessageLoadingState) {
                  return Container();
                }
                if (state is MessageLoadedState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      StreamBuilder<QuerySnapshot>(
                        stream: state.messageStream,
                        builder: (context, snapshots) {
                          if (!snapshots.hasData) {
                            return Container();
                          }
                          if (snapshots.data.docs.isNotEmpty) {
                            if (snapshots.data.metadata.hasPendingWrites ==
                                false) {
                              lastHasPendingWritesFalseMessageIndex =
                                  snapshots.data.docs.length;
                              saveValueLocal(
                                path:
                                    'messagePage/lastHasPendingWritesFalseMessageIndex/${widget.selectedUserId}',
                                value: snapshots.data.docs.length,
                              );
                            }
                            return Expanded(
                              child: ListView.builder(
//                            controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                reverse: true,
                                itemCount: snapshots.data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return MessageBubble(
                                    selectedUserPhoto1:
                                        widget.selectedUserPhoto1,
                                    message: snapshots.data.docs[index],
                                    currentUser: widget.currentUser,
                                    selectedUserDecision:
                                        widget.selectedUserDecision,
                                    selectedUserId: widget.selectedUserId,
                                    hasPendingWrites:
                                        (lastHasPendingWritesFalseMessageIndex ==
                                                null)
                                            ? null
                                            : ((snapshots.data.docs.length -
                                                        lastHasPendingWritesFalseMessageIndex) >
                                                    index) //length - last = おくれてない数 > index
                                                ? true
                                                : false,
                                  );
                                },

//                              MessageWidget(
//                                  currentUserId: widget.currentUser.uid,
//                                  messageId: snapshots
//                                      .data
//                                      .documents[snapshots.data.documents.length -
//                                      1 -
//                                      index] //indexのひとつひとつ
//                                      .documentID),
//
//                              );
                              ),
                            );
                          } else {
                            return Column(
                              children: <Widget>[
                                SizedBox(height: size.height * 0.02),
                                Text(
                                  "メッセージをはじめよう",
                                  style: TextStyle(
                                    color: black87,
                                    fontSize: size.width * 0.045,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      Container(
                        width: size.width,
//                          height: size.height * 0.08,
                        color: white,
                        child: Center(
                          child: SendMessageField(
                            size: size,
                            currentUser: widget.currentUser,
                            selectedUserId: widget.selectedUserId,
                            selectedUserName: widget.selectedUserName,
                            selectedUserPhoto1: widget.selectedUserPhoto1,
                            selectedUserDecision: widget.selectedUserDecision,
                            messageBloc: _messageBloc,
                            isFirstMessage: widget.isFirstMessage,
                            ),
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
