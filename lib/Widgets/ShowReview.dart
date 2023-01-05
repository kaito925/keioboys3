import 'package:flutter/material.dart';
import 'package:Keioboys/FB/MessageFB.dart';
import 'package:Keioboys/consts.dart';
import 'package:flutter/services.dart';
import 'package:in_app_review/in_app_review.dart';

void showReview({size, context, currentUserId}) {
  final MessageFB _messageFB = MessageFB();
  bool emptyStar1 = true;
  bool emptyStar2 = true;
  bool emptyStar3 = true;
  bool emptyStar4 = true;
  bool emptyStar5 = true;
  String numberOfStarsString;

  showDialog(
      context: context,
      builder: (_) {
        TextEditingController _textControllerForOpinion =
            TextEditingController();
        return StatefulBuilder(builder: (context, setState) {
          return Center(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: AlertDialog(
              title: Text(
                "応援をお願いします！",
              ),
              content: Container(
                width: size.width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'いつもKeioboysをご利用いただきありがとうございます。皆様の良い出会いをサポートするべく日々改善を続けています。',
                      style: TextStyle(
                        color: black87,
                        fontSize: size.width * 0.05,
                      ),
                    ),
                    SizedBox(
                      height: size.width * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(
                            (emptyStar1 == true)
                                ? Icons.star_border
                                : Icons.star,
                            color: (emptyStar1 == true)
                                ? grey
                                : Colors.orangeAccent,
                            size: size.width * 0.1,
                          ),
                          onTap: () {
                            setState(() {
                              emptyStar1 = false;
                              emptyStar2 = true;
                              emptyStar3 = true;
                              emptyStar4 = true;
                              emptyStar5 = true;
                              numberOfStarsString = 'oneStar';
                            });
                          },
                        ),
                        GestureDetector(
                          child: Icon(
                            (emptyStar2 == true)
                                ? Icons.star_border
                                : Icons.star,
                            color: (emptyStar2 == true)
                                ? grey
                                : Colors.orangeAccent,
                            size: size.width * 0.1,
                          ),
                          onTap: () {
                            setState(() {
                              emptyStar1 = false;
                              emptyStar2 = false;
                              emptyStar3 = true;
                              emptyStar4 = true;
                              emptyStar5 = true;
                              numberOfStarsString = 'twoStars';
                            });
                          },
                        ),
                        GestureDetector(
                          child: Icon(
                            (emptyStar3 == true)
                                ? Icons.star_border
                                : Icons.star,
                            color: (emptyStar3 == true)
                                ? grey
                                : Colors.orangeAccent,
                            size: size.width * 0.1,
                          ),
                          onTap: () {
                            setState(() {
                              emptyStar1 = false;
                              emptyStar2 = false;
                              emptyStar3 = false;
                              emptyStar4 = true;
                              emptyStar5 = true;
                              numberOfStarsString = 'threeStars';
                            });
                          },
                        ),
                        GestureDetector(
                          child: Icon(
                            (emptyStar4 == true)
                                ? Icons.star_border
                                : Icons.star,
                            color: (emptyStar4 == true)
                                ? grey
                                : Colors.orangeAccent,
                            size: size.width * 0.1,
                          ),
                          onTap: () {
                            setState(() {
                              emptyStar1 = false;
                              emptyStar2 = false;
                              emptyStar3 = false;
                              emptyStar4 = false;
                              emptyStar5 = true;
                              numberOfStarsString = 'fourStars';
                            });
                          },
                        ),
                        GestureDetector(
                          child: Icon(
                            (emptyStar5 == true)
                                ? Icons.star_border
                                : Icons.star,
                            color: (emptyStar5 == true)
                                ? grey
                                : Colors.orangeAccent,
                            size: size.width * 0.1,
                          ),
                          onTap: () {
                            setState(() {
                              emptyStar1 = false;
                              emptyStar2 = false;
                              emptyStar3 = false;
                              emptyStar4 = false;
                              emptyStar5 = false;
                              numberOfStarsString = 'fiveStars';
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.width * 0.05,
                    ),
                    (numberOfStarsString == null)
                        ? Container()
                        : (numberOfStarsString == 'fourStars' ||
                                numberOfStarsString == 'fiveStars')
                            ? Container(
                                height: size.height * 0.06,
                                child: FlatButton(
                                  child: Center(
                                    child: Text(
                                      'レビューする',
                                      style: TextStyle(
                                        color: pink,
                                        fontSize: size.width * 0.05,
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final InAppReview inAppReview =
                                        InAppReview.instance;
                                    inAppReview.openStoreListing(
                                        appStoreId: '1535177691');
                                    _messageFB.sendStars(
                                      currentUserId: currentUserId,
                                      numberOfStarsString: numberOfStarsString,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                ),
                              )
                            : Container(
                                height: size.height * 0.06,
                                child: FlatButton(
                                  child: Center(
                                    child: Text(
                                      '改善点を送る',
                                      style: TextStyle(
                                        color: pink,
                                        fontSize: size.width * 0.05,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        TextEditingController
                                            _textControllerForOpinion =
                                            TextEditingController();
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return Center(
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      FocusScope.of(context)
                                                          .unfocus(),
                                                  child: AlertDialog(
                                                    title: Text("改善点を送る"),
                                                    content: Container(
                                                      width: size.width * 0.9,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Text(
                                                            'ご協力ありがとうございます。皆様により良い体験をしていただくため運営チーム一同努めてまいります。',
                                                            style: TextStyle(
                                                              color: black87,
                                                              fontSize:
                                                                  size.width *
                                                                      0.05,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: size.width *
                                                                0.05,
                                                          ),
                                                          TextFormField(
                                                            controller:
                                                                _textControllerForOpinion,
                                                            cursorColor: pink,
                                                            decoration:
                                                                InputDecoration(
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color:
                                                                      black87,
                                                                  width:
                                                                      size.width *
                                                                          0.002,
                                                                ),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color:
                                                                      black87,
                                                                  width:
                                                                      size.width *
                                                                          0.002,
                                                                ),
                                                              ),
                                                              labelText: '改善点',
                                                              labelStyle:
                                                                  TextStyle(
                                                                color: black87,
                                                              ),
                                                            ),
                                                            autofocus: true,
                                                            minLines: 4,
                                                            maxLines: null,
                                                            maxLengthEnforcement:
                                                                MaxLengthEnforcement
                                                                    .none,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        splashColor: lightGrey,
                                                        child: Text(
                                                          "送信",
                                                          style: TextStyle(
                                                            color: pink,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          _messageFB
                                                              .sendOpinion(
                                                            currentUserId:
                                                                currentUserId,
                                                            opinion:
                                                                _textControllerForOpinion
                                                                    .text,
                                                          );
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                  ],
                ),
              ),
            ),
          ));
        });
      });
}
