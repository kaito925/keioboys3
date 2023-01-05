// 名前9字以内ここでは(9/19)
//fsok

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Keioboys/FB/MatchFB.dart';
import 'package:Keioboys/FB/MessageFB.dart';
import 'package:Keioboys/MessageTab/LastMessage.dart';
import 'package:Keioboys/MessageTab/Message.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:Keioboys/MessageTab/MessagePage.dart';
import 'package:Keioboys/FB/MessageListFB.dart';
import 'package:Keioboys/MessageTab/ProfilePage.dart';
import 'package:Keioboys/Widgets/GetDistance.dart';
import 'package:Keioboys/Widgets/ShowImageFromURL.dart';
import 'package:Keioboys/Widgets/SlideRoute.dart';
import 'package:Keioboys/consts.dart';
import 'package:flutter/material.dart';
import 'package:Keioboys/Widgets/ShortDate.dart';
import 'package:Keioboys/Widgets/fake_ui.dart' if (dart.library.html) 'dart:ui'
    as ui;
import 'package:universal_html/html.dart' as html;

class MessageListWidget extends StatefulWidget {
  final String selectedUserId;
  final String selectedUserName;
  final String selectedUserPhoto1;
//  final Timestamp creationTime;
  final String selectedUserDecision;
  final String currentUserDecision;
  final UserData currentUser;
  final bool firstMessageFromMe;
  final String lastMessage;
  final Timestamp lastMessageTime;
  final bool newMessage;

  MessageListWidget({
//    this.creationTime,
    this.selectedUserId,
    this.selectedUserName,
    this.selectedUserPhoto1,
    this.selectedUserDecision,
    this.currentUserDecision,
    this.currentUser,
    this.firstMessageFromMe,
    this.lastMessage,
    this.lastMessageTime,
    this.newMessage,
  });

  @override
  _MessageListWidgetState createState() => _MessageListWidgetState();
}

class _MessageListWidgetState extends State<MessageListWidget> {
//  MessageListFB _messageListFB = MessageListFB();
  MessageFB _messageFB = MessageFB();
  MatchFB matchFB = MatchFB();
//  LastMessage chatModel;
//  UserData selectedUser;
//  List matchedUserList;

//  getUserDetail() async {
//    selectedUser = await matchFB.getUserDetails(
//      userId: widget.selectedUserId,
//      decision: widget.selectedUserDecision,
//    );
////    matchedUserList.add(matchedUser);
//    Message lastMessage = await _messageListFB
//        .getLastMessage(
//            currentUserId: widget.currentUser.uid,
//            selectedUserId: widget.selectedUserId)
//        .catchError((error) {
//      print(error);
//    });
//
//    if (lastMessage == null) {
//      //lastmessageと相手のname,photoをsnapshotに
//      return LastMessage(
////          name: matchedUser.name,
////          photo: matchedUser.photo,
//          lastMessage: null,
////          lastMessagePhoto: null,
//          timestamp: null);
//    } else {
//      return LastMessage(
////          name: matchedUser.name,
////          photo: matchedUser.photo,
//          lastMessage: lastMessage.text,
////          lastMessagePhoto: message.photoUrl,
//          timestamp: lastMessage.timeStamp);
//    }
//  }

//  deleteChat() async {
//    await messagesRepo.deleteChat(
//        currentUserId: widget.userId, selectedUserId: widget.selectedUserId);
//  }

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
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.width * 0.27,
          width: size.width,
          decoration: BoxDecoration(
            color: transparent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      UserData selectedUser;
                      selectedUser = await matchFB.getUserDetails(
                        userId: widget.selectedUserId,
                        decision: widget.selectedUserDecision,
                      );
                      int distance = await getDistance(selectedUser.location);
                      widget.currentUser.decision = widget.currentUserDecision;
                      Navigator.of(context).push(
                        slideRoute(
                          ProfilePage(
                            currentUser: widget.currentUser,
                            selectedUser: selectedUser,
                            fromMessage: true,
                            distance: distance,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(size.width * 0.15),
                      child: Stack(
                        children: [
                          Container(
                            height: size.width * 0.18,
                            width: size.width * 0.18,
                            child: (web)
                                ? HtmlElementView(
                                    viewType: imageUrl,
                                  )
                                : ShowImageFromURL(
                                    photoURL: widget.selectedUserPhoto1,
                                  ),
                          ),
                          Container(
                            height: size.width * 0.18,
                            width: size.width * 0.18,
                            color: transparent,
                          ),
                        ],
                      ),
                    ),
                  ),
//                Stack(
//                  children: [
//                    ClipRRect(
//                      borderRadius: BorderRadius.circular(size.width * 0.15),
//                      child: Container(
//                        height: size.width * 0.18,
//                        width: size.width * 0.18,
//                        child: (web)
//                            ? HtmlElementView(
//                                viewType: imageUrl,
//                              )
//                            : ShowImageFromURL(
//                                photoURL: widget.selectedUserPhoto1,
//                              ),
//                      ),
//                    ),
//
//
//                    GestureDetector(
//                      child: Container(
//                        height: size.width * 0.18,
//                      ),
//                      onTap: () async {
//                        UserData selectedUser;
//                        selectedUser = await matchFB.getUserDetails(
//                          userId: widget.selectedUserId,
//                          decision: widget.selectedUserDecision,
//                        );
//                        int distance = await getDistance(selectedUser.location);
//                        widget.currentUser.decision =
//                            widget.currentUserDecision;
////                        Navigator.of(context).push(
////                          slideRoute(
////                            ProfilePage(
////                              currentUser: widget.currentUser,
////                              selectedUser: selectedUser,
////                              fromMessage: true,
////                              distance: distance,
////                            ),
////                          ),
////                        );
//                      },
//                    ),
//                  ],
//                ),
                  SizedBox(
                    width: size.width * 0.03,
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        widget.currentUser.decision =
                            widget.currentUserDecision;
                        _messageFB.updateLastOpenedTime(
                          currentUserId: widget.currentUser.uid,
                          selectedUserId: widget.selectedUserId,
                        );

                        Navigator.of(context).push(
                          slideRoute(
                            MessagePage(
                              currentUser: widget.currentUser,
                              selectedUserId: widget.selectedUserId,
                              selectedUserName: widget.selectedUserName,
                              selectedUserPhoto1: widget.selectedUserPhoto1,
                              selectedUserDecision: widget.selectedUserDecision,
                              isFirstMessage: false,
                              firstMessageFromMe: widget.firstMessageFromMe,
                            ),
                          ),
                        );
                      } catch (error) {
                        print('error: $error');
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: size.width * 0.05,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: size.width * 0.51,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      widget.selectedUserName,
                                      style: TextStyle(
                                        color: black87,
                                        fontSize: size.width * 0.05,
                                      ),
                                      maxLines: 1,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.01,
                                    ),
                                    (widget.currentUserDecision ==
                                                'superLike' ||
                                            widget.selectedUserDecision ==
                                                'superLike')
                                        ? Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                            size: size.width * 0.058,
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                width: size.width * 0.175,
                                child: (widget.lastMessageTime != null)
                                    ? shortDateWidget(
                                        date: widget.lastMessageTime.toDate(),
                                        size: size.width * 0.032,
                                      )
                                    : Container(),
//                                        : shortDateWidget(
//                                            date: widget.creationTime.toDate(),
//                                            size: size.height * 0.015),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.width * 0.015,
                          ),
                          (widget.lastMessage != null)
                              ? Container(
                                  width: size.width * 0.72,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: size.width * 0.64,
                                        child: Text(
                                          '${widget.lastMessage}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: black87,
                                            fontSize: size.width * 0.04,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.02,
                                      ),
                                      (widget.newMessage == true)
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      size.width * 0.15),
                                              child: Container(
                                                color: pink,
                                                height: size.width * 0.05,
                                                width: size.width * 0.05,
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                )
//                                      )
                              : Container()
//                              chat.lastMessagePhoto == null
//                                      ? Text("チャットをはじめよう！")
//                                      : Row(
//                                          children: <Widget>[
//                                            Icon(
//                                              Icons.photo,
//                                              color: Colors.grey,
//                                              size: size.height * 0.02,
//                                            ),
//                                            Text(
//                                              "画像",
//                                              style: TextStyle(
//                                                  fontSize: size.height * 0.015,
//                                                  color: Colors.grey),
//                                            )
//                                          ],
//                                        )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
//                      (chat.timestamp != null)
//                          ? dateWidget(
//                              date: chat.timestamp.toDate(), size: size)
//                          : dateWidget(
//                              date: widget.creationTime.toDate(), size: size)

//                        (chat.timestamp.toDate().minute.toString().length ==
//                                  1)
//                              ? Text(chat.timestamp.toDate().year.toString() +
//                                  '年' +
//                                  chat.timestamp.toDate().month.toString() +
//                                  '月' +
//                                  chat.timestamp.toDate().day.toString() +
//                                  '日' +
//                                  weekday(chat.timestamp.toDate().weekday) +
//                                  chat.timestamp.toDate().hour.toString() +
//                                  ":0" +
//                                  chat.timestamp.toDate().minute.toString())
//                              : Text(chat.timestamp.toDate().year.toString() +
//                                  '年' +
//                                  chat.timestamp.toDate().month.toString() +
//                                  '月' +
//                                  chat.timestamp.toDate().day.toString() +
//                                  '日' +
//                                  weekday(chat.timestamp.toDate().weekday) +
//                                  chat.timestamp.toDate().hour.toString() +
//                                  ":" +
//                                  chat.timestamp.toDate().minute.toString())
//                          : (widget.creationTime
//                                      .toDate()
//                                      .minute
//                                      .toString()
//                                      .length ==
//                                  1)
//                              ? Text(
//                                  widget.creationTime.toDate().hour.toString() +
//                                      ":0" +
//                                      widget.creationTime
//                                          .toDate()
//                                          .minute
//                                          .toString())
//                              : Text(
//                                  widget.creationTime.toDate().hour.toString() +
//                                      ":" +
//                                      widget.creationTime
//                                          .toDate()
//                                          .minute
//                                          .toString())
            ],
          ),
        ),
        Container(height: 0.5, color: lightGrey),
      ],
    );
  }
}
