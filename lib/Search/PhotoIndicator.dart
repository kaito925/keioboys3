//著作ok

import 'package:Keioboys/Widgets/UserData.dart';
import 'package:Keioboys/FB/MessageFB.dart';
import 'package:Keioboys/MessageTab/MessageBloc/MessageBloc.dart';
import 'package:flutter/material.dart';
import 'package:Keioboys/Widgets/ShowImageFromURL.dart';
import 'package:flutter/cupertino.dart';
import 'package:Keioboys/consts.dart';
import 'package:Keioboys/Widgets/fake_ui.dart' if (dart.library.html) 'dart:ui'
    as ui;
import 'package:universal_html/html.dart' as html;

class PhotoIndicator extends StatefulWidget {
  final String photo;
  final int photoNumber;
  final int photoCount;
  final UserData currentUser;
  final UserData selectedUser;
  final bool fromDetail;

  const PhotoIndicator({
    this.photo,
    this.photoNumber,
    this.photoCount,
    this.currentUser,
    this.selectedUser,
    this.fromDetail,
  });
  @override
  _PhotoIndicatorState createState() => _PhotoIndicatorState();
}

class _PhotoIndicatorState extends State<PhotoIndicator> {
  MessageFB _messageFB = MessageFB();
  MessageBloc _messageBloc;
  bool report;

  @override
  void initState() {
//    report = false;
    _messageBloc = MessageBloc(messageFB: _messageFB);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl;
    if (web) {
      imageUrl = widget.photo;
      ui.platformViewRegistry.registerViewFactory(
        imageUrl,
        (int _) => html.ImageElement()..src = imageUrl,
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        (web)
            ? HtmlElementView(
                viewType: imageUrl,
              )
            : ShowImageFromURL(
                photoURL: widget.photo,
              ),
        photoIndicator(),
      ],
    );
  }

  Widget photoIndicator() {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Container(
            height: size.height * 0.05,
            width: size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(25),
                  transparent,
                ],
              ),
            ),
            child: (widget.photoCount != 1)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _indicator(size),
                  )
                : Container(),
          ),
          (web)
              ? Container(
                  height: (widget.fromDetail == true)
                      ? size.height * 0.45
                      : size.height * 0.63,
                  width: size.width,
                  color: transparent,
                )
              : Container(),
        ],
      ),
    );
  }

  List<Widget> _indicator(size) {
    List<Widget> photoIndicator = [];
    for (int i = 0; i < widget.photoCount; i++) {
      photoIndicator.add(
        (i == widget.photoNumber - 1)
            ? Padding(
                padding: EdgeInsets.only(
                  top: size.width * 0.02,
                  left: size.width * 0.01,
                  right: size.width * 0.01,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(size.width * 0.15),
                  child: Container(
                    color: white,
                    height: size.width * 0.02,
                    width: size.width * 0.02,
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.only(
                  top: size.width * 0.02,
                  left: size.width * 0.01,
                  right: size.width * 0.01,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(size.width * 0.15),
                  child: Container(
                    height: size.width * 0.02,
                    width: size.width * 0.02,
                    color: transparentBlack,
                  ),
                ),
              ),
      );
    }
    return photoIndicator;
  }
}
