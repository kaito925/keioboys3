import 'package:Keioboys/FB/MatchFB.dart';
import 'package:Keioboys/FB/MessageFB.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:Keioboys/MessageTab/AgeVerificationPage.dart';
import 'package:Keioboys/MessageTab/MatchBloc/MatchBloc.dart';
import 'package:Keioboys/MessageTab/MatchBloc/MatchEvent.dart';
import 'package:Keioboys/MessageTab/MatchBloc/MatchState.dart';
import 'package:Keioboys/MessageTab/Message.dart';
import 'package:Keioboys/Widgets/CircleButton.dart';
import 'package:Keioboys/Widgets/ShowReview.dart';
import 'package:Keioboys/Widgets/SlideRoute.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../consts.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:math' as math;

String message;

class SendMessageField extends StatefulWidget {
  final Size size;
  final UserData currentUser;
//  final UserData selectedUser;
  final messageBloc;
  final bool isFirstMessage;
  final String selectedUserId;
  final String selectedUserName;
  final String selectedUserPhoto1;
  final String selectedUserDecision;

  SendMessageField({
    this.size,
    this.currentUser,
//    this.selectedUser,
    this.messageBloc,
    this.isFirstMessage,
    this.selectedUserId,
    this.selectedUserName,
    this.selectedUserPhoto1,
    this.selectedUserDecision,
  });

  @override
  _SendMessageFieldState createState() => _SendMessageFieldState();
}

class _SendMessageFieldState extends State<SendMessageField> {
  TextEditingController _messageTextController;
  FocusNode focusNode = FocusNode();
//  MessagingBloc _messagingBloc;
  Key orderKey;
  String token;
  String email;
  bool first;
  bool autoFocus;
  final UserFB _userFB = UserFB();
  MatchFB matchFB = MatchFB();
  MessageFB _messageFB = MessageFB();
  MatchBloc _matchBloc;
  //TODO いみふ
  final functions = FirebaseFunctions.instanceFor(
    region: 'asia-northeast1',
  );
  HttpsCallable sendNotification;
  HttpsCallable sendEmail;
  @override
  void initState() {
    _messageTextController = TextEditingController();
    _matchBloc = MatchBloc(matchFB: matchFB);
    first = true;
    autoFocus = true;
    sendNotification = functions.httpsCallable('sendToDevice');
    sendEmail = functions.httpsCallable('sendEmail');
    super.initState();
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder(
        bloc: _matchBloc,
        builder: (BuildContext context, LikedAndMatchState state) {
          if (state is LoadingState) {
            _matchBloc.add(GetUserEvent(
              currentUserId: widget.currentUser.uid,
            ));
            return Container();
          } else if (state is LoadAgeVerificationState) {
            return StreamBuilder(
                stream: state.ageVerificationSnapshot,
                builder: (context, snapshot) {
                  return
//      Container(
//      width: widget.size.width,
//      height: widget.size.height * 0.06,
//      color: kScaffoldBackGroundColor,
//      child:
                      Row(
                    children: <Widget>[
//                        GestureDetector(
//                          onTap: () async {
//                            File photo =
//                                await FilePicker.getFile(type: FileType.IMAGE);
//                            if (photo != null) {
//                              _messagingBloc.dispatch(SendMessageEvent(
//                                  message: Message(
//                                text: null,
//                                senderId: widget.currentUser.uid,
//                                senderName: widget.currentUser.name,
//                                selectedUserId: widget.selectedUser.uid,
//                                photo: photo,
//                              )));
//                            }
//                          },
//                          child: Padding(
//                            padding: EdgeInsets.symmetric(
//                                horizontal: size.height * 0.005),
//                            child: Icon(
//                              Icons.add,
//                              color: Colors.white,
//                              size: size.height * 0.04,
//                            ),
//                          ),
//                        ),
                      SizedBox(
                        width: widget.size.width * 0.03,
                      ),
                      Container(
                        width: widget.size.width * 0.85,
//          height: widget.size.width * 0.1,
                        padding: EdgeInsets.all(
                          widget.size.width * 0.03,
                        ),
                        decoration: BoxDecoration(
                          color: white,
                          border: Border.all(
                            color: coolGrey,
                            width: widget.size.width * 0.005,
                          ),
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: Center(
                          child: TextField(
                            key: orderKey,
                            autofocus: autoFocus,
                            controller: _messageTextController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: null,
                            textAlignVertical: TextAlignVertical.center,
                            cursorColor: pink,
                            minLines: 1,
                            maxLines: 4,
                            maxLength: 2000,
                            maxLengthEnforcement: MaxLengthEnforcement.none,

////                              focusNode: _focusNode,
////                              onSubmitted: (string) => FocusScope.of(context)
////                                  .requestFocus(_focusNode),
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          if (snapshot.data['ageVerification'] == true ||
                              widget.selectedUserId ==
                                  'hJBNCtQKnJfwlqVonB0dzUJfbrn2') {
                            if (_messageTextController.text != '' &&
                                _messageTextController.text != null) {
                              await _messageFB.sendMessage(
                                message: Message(
                                  text: _messageTextController.text,
                                  currentUserId: widget.currentUser.uid,
//                              senderName: widget.currentUser.name,
                                  selectedUserId: widget.selectedUserId,
//                              photo: null,
                                  currentUserDecision:
                                      widget.currentUser.decision,
                                  selectedUserDecision:
                                      widget.selectedUserDecision,
                                ),
                                isFirstMessage: (first == true)
                                    ? widget.isFirstMessage
                                    : false,
                                currentUserName: widget.currentUser.name,
                                currentUserPhoto1: widget.currentUser.photo1,
                                selectedUserName: widget.selectedUserName,
                                selectedUserPhoto1: widget.selectedUserPhoto1,
                              );

                              if (widget.isFirstMessage == true &&
                                  first == true &&
                                  math.Random().nextInt(5) == 1 &&
                                  widget.currentUser.review == null) {
                                autoFocus = false;
                                showReview(
                                  size: size,
                                  context: context,
                                  currentUserId: widget.currentUser.uid,
                                );
                              } else {
                                autoFocus = true;
                              }

                              widget.currentUser.review = 10000; //今回の起動では表示しない

//                            _messageTextController.clearComposing();

//              message送った後にhttpでひきだす。こっちのがよさそう。

//              print('result: ${result.data}');

                              message = _messageTextController.text;

                              if (ios) {
                                focusNode.unfocus();
                                focusNode.requestFocus();
                                _messageTextController.clear();
                              } else {
                                setState(
                                  () {
                                    orderKey = GlobalKey();
                                    _messageTextController =
                                        TextEditingController();
//                              _messageTextController.clear();
                                  },
                                );
                              }

//                            _focusNode.unfocus();

//_listViewController.jumpTo(
//  _listViewController.position.maxScrollExtent);
                              if (token == null) {
                                token = await _messageFB.getToken(
                                  userId: widget.selectedUserId,
                                );
                              }
                              if (token != '' && token != 'web') {
                                final HttpsCallableResult result =
                                    await sendNotification.call({
                                  'token': token,
                                  'sender': widget.currentUser.name,
                                  'message': message
                                });
                              } else {
                                print('first: $first');
                                if (first == true) {
                                  if (email == null) {
                                    email = await _messageFB.getEmail(
                                      userId: widget.selectedUserId,
                                    );
                                  }
                                  print('HH');
                                  var messageHtml = '''<div>
                                  <p>${widget.selectedUserName}さん</p>
                                  <p>${widget.currentUser.name}さんから新しいメッセージが届きました。</p>

                                  <div class="border border-solid" style="padding: 20px; margin: 20px; border: 1px solid #fa196e;">${message}</div>
                                  <br>
                                  <body style="text-align: center">
                                    <a href="https://keioboys.page.link/m" 
                                    style="border-radius: 5px;
                                    background-color: #fa196e;
                                    padding: 15px;
                                    text-decoration: none;
                                    color: white;
                                    ">今すぐ返信</a>
                                  </body>
                                  </div>''';
                                  final HttpsCallableResult result =
                                      await sendEmail.call({
                                    'email': '$email',
                                    'subject':
                                        '【Keioboys】 ${widget.currentUser.name}さんからの新着メッセージ',
                                    'html': messageHtml,
                                  });
                                }
                              }
                              first = false;
                            }
                          } else {
                            await Navigator.of(context).push(
                              slideRoute(
                                AgeVerificationPage(
                                  userFB: _userFB,
                                  currentUser: widget.currentUser,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: widget.size.width * 0.09,
                          width: widget.size.width * 0.12,
                          padding: EdgeInsets.symmetric(
                            horizontal: widget.size.width * 0.02,
                          ),
                          child: Icon(
                            Icons.send,
                            color: pink,
                          ),
                        ),
                      ),
//        )
                    ],
//      ),
                  );
                });
          } else
            return Container();
        });
  }
}
