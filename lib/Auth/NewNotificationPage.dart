import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Keioboys/Auth/AuthBloc/AuthBloc.dart';
import 'package:Keioboys/Auth/AuthBloc/AuthEvent.dart';
import 'package:Keioboys/FB/MessageFB.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:Keioboys/MessageTab/MessageBloc/MessageBloc.dart';
import 'package:Keioboys/MessageTab/MessageBloc/MessageEvent.dart';
import 'package:Keioboys/MessageTab/MessageBloc/MessageState.dart';
import 'package:Keioboys/Widgets/CheckLocationEnabled.dart';
import 'package:Keioboys/Widgets/HomeTab.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:Keioboys/consts.dart';

class NewNotificationPage extends StatefulWidget {
  final UserData currentUser;
  final bool fromSetting;
  final bool appOpenUpdate;

  NewNotificationPage({
    this.currentUser,
    this.fromSetting,
    this.appOpenUpdate,
  });

  @override
  _NewNotificationPageState createState() => _NewNotificationPageState();
}

class _NewNotificationPageState extends State<NewNotificationPage> {
  final UserFB _userFB = UserFB();
  final MessageFB _messageFB = MessageFB();
  MessageBloc _messageBloc;

  @override
  void initState() {
    _messageBloc = MessageBloc(messageFB: _messageFB);
    super.initState();
  }

  void appOpenUpdate() {
    print('appOpen: ${widget.currentUser.uid}');
    Size size = MediaQuery.of(context).size;
    checkLocationEnabled(
      size: size,
      context: context,
    );
    if (android || ios) {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      _firebaseMessaging.requestPermission(
          sound: true, badge: true, alert: true);
//    _firebaseMessaging.onIosSettingsRegistered
//        .listen((IosNotificationSettings settings) {});
      _firebaseMessaging.getToken().then((String token) async {
        assert(token != null);

        _userFB.updateInfo(
          currentUser: widget.currentUser,
          context: context,
        );
      });
    } else if (web) {
      _userFB.updateInfo(
        currentUser: widget.currentUser,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fromSetting != true && widget.appOpenUpdate != false) {
      appOpenUpdate();
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        title: Text(
          'お知らせ',
          style: TextStyle(
            color: pink,
          ),
        ),
        iconTheme: IconThemeData(
          color: pink,
        ),
        backgroundColor: white,
//            elevation: 0,
      ),
      body: BlocBuilder(
        bloc: _messageBloc,
        builder: (BuildContext context, MessageState state) {
          print('state: $state'); //TODO nullになってる MessageInitialState
          if (state is MessageInitialState) {
            _messageBloc.add(NotificationStreamEvent());
          }
          if (state is NotificationLoadingState) {
            return Container(
//                child: LinearProgressIndicator(),
                );
          }
          if (state is NotificationLoadedState) {
            return Padding(
              padding: EdgeInsets.only(
                left: size.width * 0.03,
                right: size.width * 0.03,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StreamBuilder(
                    stream: state.notificationStream,
                    builder: (context, snapshots) {
                      if (!snapshots.hasData) {
                        return Container();
                      }
                      if (snapshots.data.docs.isNotEmpty) {
                        return Expanded(
                          child: ListView.builder(
//                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            reverse: false,
                            itemCount: snapshots.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
//                              lastMessageTimeStamp =
//                                  snapshots.data.documents[index]['timestamp'];
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: size.width * 0.05,
                                  ),
                                  Text(
                                    '${snapshots.data.docs[index]['timestamp'].toDate().year}/${snapshots.data.docs[index]['timestamp'].toDate().month}/${snapshots.data.docs[index]['timestamp'].toDate().day}',
                                    style: TextStyle(
                                      color: black87,
                                      fontSize: size.width * 0.04,
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.width * 0.01,
                                  ),
                                  Text(
                                    '${snapshots.data.docs[index]['text']}',
                                    style: TextStyle(
                                      color: black87,
                                      fontSize: size.width * 0.05,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            width: size.width * 0.7,
                            height: size.width * 0.1,
                            decoration: BoxDecoration(
//                        border: Border.all(
//                          color: pink,
//                          width: size.width * 0.005,
//                        ),
                              color: pink,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Text(
                                '閉じる',
                                style: TextStyle(
                                  color: white,
                                  fontSize: size.width * 0.05,
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            if (widget.fromSetting == true) {
                              Navigator.pop(context);
                            } else {
                              BlocProvider.of<AuthBloc>(context).add(
                                NotificationChecked(
                                    currentUser: widget.currentUser),
                              );
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                                  return HomeTab(
                                    userFB: _userFB,
                                    currentUser: widget.currentUser,
                                    );
                                }),
                              );
                            }
                            _userFB.updateCheckedNotificationTime(
                              currentUserId: widget.currentUser.uid,
                            );
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
