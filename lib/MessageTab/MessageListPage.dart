import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:Keioboys/MessageTab/MessageListBloc/Bloc.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:Keioboys/FB/MessageListFB.dart';
import 'package:Keioboys/MessageTab/MessageListWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Keioboys/consts.dart';

class MessageListPage extends StatefulWidget {
  final UserData currentUser;

  MessageListPage({
    this.currentUser,
  });

  @override
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  MessageListFB _messageListFB = MessageListFB();
  MessageListBloc _messageListBloc;
  String urlPhoto1;

  @override
  void initState() {
    _messageListBloc = MessageListBloc(messageListRepo: _messageListFB);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: BlocBuilder(
          bloc: _messageListBloc,
          builder: (BuildContext context, MessageListState state) {
            if (state is MessageInitialState) {
              _messageListBloc.add(
                GetMessageListEvent(
                  currentUserId: widget.currentUser.uid,
                ),
              );
            }
//            if (state is LoadingState) {
//              return Center(
//                child: CircularProgressIndicator(
//                  valueColor: AlwaysStoppedAnimation(pink),
//                ),
//              );
//            }
            if (state is LoadState) {
              return StreamBuilder<QuerySnapshot>(
                stream: state.messageListStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  if (snapshot.data.docs.isNotEmpty) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Container(),
                      );
                    } else {
                      final user = snapshot.data.docs;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                        ),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: user.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (user[index]['lastMessageTime'] != null) {
                                    void downloadURL({selectedUserId}) async {
                                      print('$index: $selectedUserId');
                                      Reference refPhoto1 = FirebaseStorage
                                          .instance
                                          .ref()
                                          .child('userPhotos')
                                          .child(selectedUserId)
                                          .child('photo1');
                                      urlPhoto1 =
                                          await refPhoto1.getDownloadURL();
                                      if (urlPhoto1 !=
                                          user[index]['selectedUserPhoto1']) {
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(widget.currentUser.uid)
                                            .collection('messagingList')
                                            .doc(selectedUserId)
                                            .update({
                                          'selectedUserPhoto1': urlPhoto1
                                        });
                                      }
                                    }
                                    ////TODO すでにマッチした人の写真更新反映できない。するには下のスラッシュ外して、
                                    // TODO 全部"photo1"にしなきゃ（乱数じゃなく）だけどめんどいよ
                                    // TODO userFBのupdateProfileのとこも直す
                                    // downloadURL(selectedUserId: user[index].id);

                                    return MessageListWidget(
//                                    creationTime: snapshot.data.documents[index]
//                                        .data['timestamp'],
                                      selectedUserId: user[index].id,
                                      selectedUserDecision: user[index]
                                          ['selectedUserDecision'],
                                      selectedUserName: user[index]
                                          ['selectedUserName'],
                                      selectedUserPhoto1: user[index]
                                          ['selectedUserPhoto1'],
                                      currentUserDecision: user[index]
                                          ['currentUserDecision'],
                                      currentUser: widget.currentUser,
                                      firstMessageFromMe: user[index]
                                          ['firstMessageFromMe'],
                                      lastMessage: user[index]['lastMessage'],
                                      lastMessageTime: user[index]
                                          ['lastMessageTime'],
                                      newMessage: (user[index]['lastOpenedTime']
                                          .toDate()
                                          .isBefore(user[index][
                                                  'lastSelectedUserSentMessageTime']
                                              .toDate())),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    //マッチがいないとき
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          height: size.height * 0.35,
                        ),
                        Center(
                          child: Text(
                            'まだメッセージが届いていません。',
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              color: black54,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              );
            }
            return Container();
          }),
    );
  }
}
