import 'package:flutter/rendering.dart';
import 'package:selectable_autolink_text/selectable_autolink_text.dart';
import 'package:Keioboys/FB/MatchFB.dart';
import 'package:Keioboys/MessageTab/ProfilePage.dart';
import 'package:Keioboys/Widgets/GetDistance.dart';
import 'package:Keioboys/Widgets/ShowImageFromURL.dart';
import 'package:Keioboys/Widgets/SlideRoute.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:Keioboys/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Keioboys/Widgets/Date.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Keioboys/Widgets/fake_ui.dart' if (dart.library.html) 'dart:ui'
    as ui;
import 'package:universal_html/html.dart' as html;

class MessageBubble extends StatefulWidget {
  final message;
  final selectedUserId;
  final selectedUserPhoto1;
  final selectedUserDecision;
  final currentUser;
//  final selectedUser;
  final hasPendingWrites;
//  final String messageId;
//  final String currentUserId;

  MessageBubble({
    this.message,
    this.selectedUserId,
    this.selectedUserPhoto1,
    this.selectedUserDecision,
    this.currentUser,
//    this.selectedUser,
    this.hasPendingWrites,
//    this.messageId,
//    this.currentUserId,
  });

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  MatchFB matchFB = MatchFB();
  //  MessagingRepo _messagingRepo = new MessagingRepo();
//  Message _message;

//  Future getDetails() async {
//    _message =
//        await _messagingRepo.getMessageDetail(messageId: widget.messageId);
//
//    return _message;
//  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String imageUrl;
    if (web) {
      imageUrl = widget.selectedUserPhoto1;
      ui.platformViewRegistry.registerViewFactory(
        imageUrl,
        (int _) => html.ImageElement()..src = imageUrl,
      );
    }
//    return FutureBuilder(
//        future: getDetails(),
//        builder: (context, snap) {
//          if (!snap.hasData) {
//            return Container();
//          } else {
//            _message = snap.data;
//
    if (widget.message['text'] == null) {
      return Container();
    } else {
      return Row(
        mainAxisAlignment: (widget.message['fromMe'] == true)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          (widget.message['fromMe'] == true)
              ? Container()
              : Row(
                  children: <Widget>[
                    SizedBox(
                      width: size.width * 0.007,
                    ),
                    GestureDetector(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(size.width * 0.045),
                        child: Stack(
                          children: [
                            Container(
                              height: size.width * 0.09,
                              width: size.width * 0.09,
                              child: (web)
                                  ? HtmlElementView(
                                      viewType: imageUrl,
                                    )
                                  : ShowImageFromURL(
                                      photoURL: widget.selectedUserPhoto1,
                                    ),
                            ),
                            Container(
                              height: size.width * 0.09,
                              width: size.width * 0.09,
                              color: transparent,
                            ),
                          ],
                        ),
                      ),
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
                    ),
                    SizedBox(
                      width: size.width * 0.005,
                    ),
                  ],
                ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.horizontal,
            children: <Widget>[
              (widget.message['fromMe'] == true)
                  ? (widget.hasPendingWrites == true)
                      ? Padding(
                          padding: EdgeInsets.only(
                            top: size.width * 0.04,
                          ),
                          child: Container(
                            width: size.width * 0.04,
                            height: size.width * 0.04,
                            child: CircularProgressIndicator(
                              strokeWidth: size.width * 0.005,
                              valueColor: AlwaysStoppedAnimation(pink),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                            top: size.width * 0.055,
                          ),
                          child: (widget.message['timestamp'] == null)
                              ? Container()
                              : dateWidget(
                                  date: widget.message['timestamp'].toDate(),
                                  size: size.width * 0.028,
                                ), //できれば時間バブルの下に合わせたい(いつか、割とどうでもいい)
                        )
                  : Container(),
//                      (widget.message['timestamp']
//                                  .toDate()
//                                  .minute
//                                  .toString()
//                                  .length ==
//                              1)
//                          ? Text(widget.message['timestamp']
//                                  .toDate()
//                                  .hour
//                                  .toString() +
//                              ":0" +
//                              widget.message['timestamp']
//                                  .toDate()
//                                  .minute
//                                  .toString())
//                          : Text(widget.message['timestamp']
//                                  .toDate()
//                                  .hour
//                                  .toString() +
//                              ":" +
//                              widget.message['timestamp']
//                                  .toDate()
//                                  .minute
//                                  .toString())),
              Padding(
                padding: EdgeInsets.all(
                  size.width * 0.012,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: size.width * 0.7,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: (widget.message['fromMe'] == true)
                          ? coolGrey
//                          ? pink
//                          : Colors.grey[300],
                          : white,
                      border: Border.all(
                        color: coolGrey,
                        width: size.width * 0.004,
                      ),
                      borderRadius: (widget.message['fromMe'] == true)
                          ? BorderRadius.all(
                              Radius.circular(
                                20,
                              ),
                            )
                          : BorderRadius.all(
                              Radius.circular(
                                20,
                              ),
                            ),
                    ),
                    padding: EdgeInsets.all(
                      size.width * 0.02,
                    ),
                    child: SelectableAutoLinkText(
                      "${widget.message['text']}",
                      linkStyle: TextStyle(color: pink),
                      highlightedLinkStyle: TextStyle(
                        color: pink,
                        backgroundColor: pink.withAlpha(0x33),
                      ),
                      onTap: (url) => launch(url, forceSafariVC: false),
//                      onLongPress: (url) => Share.share(url),
                    ),

//                    Text(
//                      "${widget.message['text']}",
//                      style: TextStyle(
//                        color:
////                          (widget.message['fromMe'] == true)
////                              ? white
////                              :
//                            black87,
//                      ),
//                    ),
                  ),
                ),
              ),
              (widget.message['fromMe'] == true)
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(
                        top: size.width * 0.055,
                      ),
                      child: dateWidget(
                        date: widget.message['timestamp'].toDate(),
                        size: size.width * 0.028,
                      ),
//                      (widget.message['timestamp']//なにこれ？もういらん？
//                                  .toDate()
//                                  .minute
//                                  .toString()
//                                  .length ==
//                              1)
//                          ? Text(widget.message['timestamp']
//                                  .toDate()
//                                  .hour
//                                  .toString() +
//                              ":0" +
//                              widget.message['timestamp']
//                                  .toDate()
//                                  .minute
//                                  .toString())
//                          : Text(widget.message['timestamp']
//                                  .toDate()
//                                  .hour
//                                  .toString() +
//                              ":" +
//                              widget.message['timestamp']
//                                  .toDate()
//                                  .minute
//                                  .toString()),
                    ),
            ],
          )
        ],
      );
    }
  }
}
