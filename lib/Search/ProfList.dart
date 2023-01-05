//TODO testflight
// superlikeマーク付けた確認
//　decisionとかcountとかfirestoreと動きあってるかテスト

//TODO ストア申請後→レビューしてね（3人マッチしたとき。7人マッチしたとき。15人マッチしたとき。30マッチしたとき。50マッチしたとき。いいわるいきく→いいならストアレビュー）
//https://pub.dev/packages/launch_review 簡単そう

//TODO 定期バックアップ
// firestoreのbuckup(firebase https://qiita.com/dowanna6/items/c56a29ff796142250d6c
// storage: https://stackoverflow.com/questions/46369844/is-it-a-way-to-backup-data-in-firebase-storage)

//TODO リリース

//TODO 課金実装(cloud function使う、課金の広告も https://qiita.com/YuKiO-OO/items/a0fe8e0a256afbb69fc7)
// ブースト実装(firestoreにスコアアップなんか途中までやったような)（時間切れはfunctionか）
// 既読(課金機能。相手のlastOpenedTimeつかえば簡単にできそう)
// 最終ログイン時間（課金機能。登録すれば、簡単にできそう。）
// 年齢・距離非表示（課金機能。cityのvisibleとおなじ感じでできる。）
// goldlike???マッチしてないのにメッセージ送れる(課金: 1回100円？)

//TODO 広告。ダウンロード5000超えたらかな？(初めはユーザー満足度優先)
// 広告1クリック10円~30円
// 10000ユーザーの半分が1日1回クリックすれば、5万~15万?月150~450?でかくね？

//TODO ずっと気を付ける
// 全体デザイン(色、サイズ、dialogの選択し青くなってる, タッチの範囲、タッチの色、splashとかlogin, signup page)
// エラーメッセージ表示
// 著作権
// いろいろ説明文

//TODO　人探す
// Simejiで未確定のひらがな消す方法

//TODO　小さな改善（重要順）
// firebase performance, test lab
// ip address, macアドレス etc
//　マーケプッシュ通知送る（firebase cloud messaging）
// 20人見たか・5人いいねしたか・1人超したか
// ログイン日数
// 登録はやく
// 今日のライク率見えるように
// リロードすれば20人以上見れるな
// status bar 色
// エラーメッセージ整理
// メッセージ最初ひらけない（きのせい?）
// 通知マークふやす（既読と似た方法で。いつ最後に通知きたかいつ最後にひらいたか登録して比較）
// アップデート終了確認（checkContinueAppと同じ感じ）
// メッセージのURL開けるように
// メッセージ売ってる最中に違う画面行っても消えないようにする(https://kwmt27.net/2020/03/26/the-technology-behind-flutter-chat-app/)
// スワイプをリセット（noした人もっかい見れる）
// メッセージ個数総計（同じような場合分けとともに）
// 削除しても1ヶ月は帰ってこれる（deletedUserから復活。authは消さないで1ヶ月後にfunctionで消す）
// 削除functionにして手動でBANしたとき？
// ユーザー検索早くする方法(？)
// メール再送信がpopせんしflushでん(dialog stateにする？)
// 起動した瞬間、ページ開く前にいろいろ画像読み込んでしまう（？）
// 時間タイムゾーンokそう？
// report数記録してスコア下げる＆自動警告
//　firestore系functionにしちゃう?

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Keioboys/MessageTab/MessagePage.dart';
import 'package:Keioboys/Widgets/CircleButton.dart';
import 'package:Keioboys/Widgets/SlideRoute.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:Keioboys/FB/MatchFB.dart';
import 'package:Keioboys/FB/SearchFB.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:Keioboys/MessageTab/Match/Decision.dart';
import 'package:Keioboys/MessageTab/Match/ProfIndex.dart';
import 'package:Keioboys/Search/Prof/Prof1AndBack.dart';
import 'package:Keioboys/Search/Prof/Prof2.dart';
import 'package:Keioboys/Search/Prof/Prof3.dart';
import 'package:Keioboys/Search/Prof/Prof4.dart';
import 'package:Keioboys/Search/Prof/Prof5.dart';
import 'package:Keioboys/Search/Prof/Prof6.dart';
import 'package:Keioboys/Search/Prof/ProfDetail1.dart';
import 'package:Keioboys/Search/Prof/ProfDetail2.dart';
import 'package:Keioboys/Search/Prof/ProfDetail3.dart';
import 'package:Keioboys/Search/Prof/ProfDetail4.dart';
import 'package:Keioboys/Search/Prof/ProfDetail5.dart';
import 'package:Keioboys/Search/Prof/ProfDetail6.dart';
import 'package:Keioboys/Search/Swipe.dart';
import 'package:Keioboys/Widgets/HomeTab.dart';
import 'package:Keioboys/Widgets/ShowImageFromURL.dart';
import 'package:Keioboys/consts.dart';
import 'package:Keioboys/Widgets/fake_ui.dart' if (dart.library.html) 'dart:ui'
    as ui;
import 'package:universal_html/html.dart' as html;

bool match;
bool subscriptionInvitation;
int cardCountToday;
int likeCountToday;
int superLikeCountToday;
typedef UpdateCallback = void Function(bool update);

class ProfList extends StatefulWidget {
  final ProfIndex profIndex;
  final UserData currentUser;
//  final bool update;
  final int searchUserListLength;
  final UserFB userFB;
  final SearchFB searchFB;
  final UpdateCallback updateCallback;

  ProfList({
    Key key,
    this.profIndex,
    this.currentUser,
//    this.update,
    this.searchUserListLength,
    this.userFB,
    this.searchFB,
    this.updateCallback,
  });

  @override
  _ProfListState createState() => _ProfListState();
}

class _ProfListState extends State<ProfList> {
  Key _frontProfKey;
  Key _backProfKey;
  Decision _currentSearch;
  Decision _nextSearch;
  DecisionIndicator decisionIndicator;
  int searchUserCount;
  MatchFB _matchFB = MatchFB();
  Size size;
//  String buttonDecision;
  bool detail;
  int photoCount;
  int photoNumber;
  bool buildUnDetailFirst;
  int distanceFront;
  double _nextProfSize = 0.9;
  List cardCountTodayList;

  @override
  void initState() {
    widget.profIndex.addListener(_goNextProf);
    _currentSearch = widget.profIndex.currentProf;
    _nextSearch = widget.profIndex.nextProf;
    _currentSearch.addListener(_setState);
    _frontProfKey = Key(_currentSearch.selectedUser.uid);
    _backProfKey = Key(_nextSearch.selectedUser.uid);
    searchUserCount = 0;
    match = false;
    subscriptionInvitation = false;
    detail = false;
    photoNumber = 1;
    photoCount = 0;
    if (widget.profIndex.currentProf.selectedUser.photo1 != null &&
        widget.profIndex.currentProf.selectedUser.photo1 != '') {
      photoCount++;
    }
    if (widget.profIndex.currentProf.selectedUser.photo2 != null &&
        widget.profIndex.currentProf.selectedUser.photo2 != '') {
      photoCount++;
    }
    if (widget.profIndex.currentProf.selectedUser.photo3 != null &&
        widget.profIndex.currentProf.selectedUser.photo3 != '') {
      photoCount++;
    }
    if (widget.profIndex.currentProf.selectedUser.photo4 != null &&
        widget.profIndex.currentProf.selectedUser.photo4 != '') {
      photoCount++;
    }
    if (widget.profIndex.currentProf.selectedUser.photo5 != null &&
        widget.profIndex.currentProf.selectedUser.photo5 != '') {
      photoCount++;
    }
    if (widget.profIndex.currentProf.selectedUser.photo6 != null &&
        widget.profIndex.currentProf.selectedUser.photo6 != '') {
      photoCount++;
    }
    getDistance(widget.profIndex.currentProf.selectedUser.location);
//    getLikeCountList();
    super.initState();
    //                likeCount: likeCountList[0],
//                superLikeCount: likeCountList[1],
  }

//  void getLikeCountList() async {
//    cardCountList = await widget.searchFB.getLikeCountList(widget.currentUser.uid,);
//  }

  @override
  void dispose() {
    if (_currentSearch != null) {
      _currentSearch.removeListener(_setState);
    }
    widget.profIndex.removeListener(_goNextProf);
    super.dispose();
  }

  @override
  void didUpdateWidget(ProfList oldWidget) {
    print('card_stack: didUpdateWidget');
    super.didUpdateWidget(oldWidget);
    if (widget.profIndex != oldWidget.profIndex) {
      oldWidget.profIndex.removeListener(_goNextProf);
      widget.profIndex.addListener(_goNextProf);
    }
    if (_currentSearch != null) {
      _currentSearch.removeListener(_setState);
    }
    _currentSearch = widget.profIndex.currentProf;
    _nextSearch = widget.profIndex.nextProf;
    if (_currentSearch != null) {
      _currentSearch.addListener(_setState);
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        setState(() {
          detail = false;
        });
        return Future.value(false);
      },
      child: (match == true)
          ? Swipe(
//        prof: Stack(
//          children: <Widget>[
//            _prof1(),
//            Text('マッチ！！')
//          ],
//        ),
              prof: _notifyMatch(),
//        prof: _notifyMatch(),
              swipeDirection: _swipeDirection(),
              swipeUpdate: _calculateBackCardSize,
              showingPlaceUpdate: _decisionIndicatorUpdate,
              swipeComplete: _swipeCompleteNotifyMatch,
            )
          : (subscriptionInvitation == true)
              ? Swipe(
                  prof: _showSubscriptionInvitation(),
                  swipeDirection: _swipeDirection(),
                  swipeUpdate: _calculateBackCardSize,
                  showingPlaceUpdate: _decisionIndicatorUpdate,
                  swipeComplete: _swipeCompleteNotifyInvitation,
                )
              : (widget.searchUserListLength < 2)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '新しい人は見つかりませんでした。',
                            style: TextStyle(
                              color: black87,
                              fontSize: size.width * 0.045,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          GestureDetector(
                            child: Container(
                              width: size.width * 0.7,
                              height: size.width * 0.1,
                              decoration: BoxDecoration(
                                color: pink,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  '更新する',
                                  style: TextStyle(
                                    color: white,
                                    fontSize: size.width * 0.05,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              //TODO
                              widget.updateCallback(true);
//              Navigator.of(context).pushReplacement(
//                MaterialPageRoute(
//                  builder: (context) {
//                    return HomeTab(
//                      userFB: widget.userFB,
//                      currentUser: widget.currentUser,
//                    );
//                  },
//                ),
//              );
                            },
                          ),
                        ],
                      ),
                    )
                  : (searchUserCount < widget.searchUserListLength - 2)
                      ? Stack(children: <Widget>[
                          Swipe(
                            front: false,
                            prof: _profBack(),
                          ),
                          (photoNumber == 1)
                              ? Swipe(
                                  prof: _prof1(),
                                  profDetail: _profDetail1(),
                                  swipeDirection: _swipeDirection(),
                                  swipeUpdate: _calculateBackCardSize,
                                  showingPlaceUpdate: _decisionIndicatorUpdate,
                                  swipeComplete: _swipeComplete,
                                  detail: detail,
                                  photoNumber: photoNumber,
                                  photoCount: photoCount,
                                  photoNumberCallback:
                                      (int photoNumberCallback) {
                                    setState(() {
                                      photoNumber = photoNumberCallback;
                                      print('photoNumberNext: $photoNumber');
                                    });
                                  },
//                            buildFirstCallback: (bool buildFirstCallback) {
//                              if (buildFirstCallback == false) {
//                                buildFirst = false;
//                              }
//                            },
                                  buildFirst: buildUnDetailFirst,
                                )
                              : (photoNumber == 2)
                                  ? Swipe(
                                      prof: _prof2(),
                                      profDetail: _profDetail2(),
                                      swipeDirection: _swipeDirection(),
                                      swipeUpdate: _calculateBackCardSize,
                                      showingPlaceUpdate:
                                          _decisionIndicatorUpdate,
                                      swipeComplete: _swipeComplete,
                                      detail: detail,
                                      photoNumber: photoNumber,
                                      photoCount: photoCount,
                                      photoNumberCallback:
                                          (int photoNumberCallback) {
                                        setState(() {
                                          photoNumber = photoNumberCallback;
                                          print(
                                              'photoNumberNext: $photoNumber');
                                        });
                                      },
//                                buildFirstCallback: (bool buildFirstCallback) {
//                                  if (buildFirstCallback == false) {
//                                    buildFirst = false;
//                                  }
//                                },
                                      buildFirst: buildUnDetailFirst,
                                    )
                                  : (photoNumber == 3)
                                      ? Swipe(
                                          prof: _prof3(),
                                          profDetail: _profDetail3(),
                                          swipeDirection: _swipeDirection(),
                                          swipeUpdate: _calculateBackCardSize,
                                          showingPlaceUpdate:
                                              _decisionIndicatorUpdate,
                                          swipeComplete: _swipeComplete,
                                          detail: detail,
                                          photoNumber: photoNumber,
                                          photoCount: photoCount,
                                          photoNumberCallback:
                                              (int photoNumberCallback) {
                                            setState(() {
                                              photoNumber = photoNumberCallback;
                                              print(
                                                  'photoNumberNext: $photoNumber');
                                            });
                                          },
//                                    buildFirstCallback:
//                                        (bool buildFirstCallback) {
//                                      if (buildFirstCallback == false) {
//                                        buildFirst = false;
//                                      }
//                                    },
                                          buildFirst: buildUnDetailFirst,
                                        )
                                      : (photoNumber == 4)
                                          ? Swipe(
                                              prof: _prof4(),
                                              profDetail: _profDetail4(),
                                              swipeDirection: _swipeDirection(),
                                              swipeUpdate:
                                                  _calculateBackCardSize,
                                              showingPlaceUpdate:
                                                  _decisionIndicatorUpdate,
                                              swipeComplete: _swipeComplete,
                                              detail: detail,
                                              photoNumber: photoNumber,
                                              photoCount: photoCount,
                                              photoNumberCallback:
                                                  (int photoNumberCallback) {
                                                setState(() {
                                                  photoNumber =
                                                      photoNumberCallback;
                                                  print(
                                                      'photoNumberNext: $photoNumber');
                                                });
                                              },
//                                        buildFirstCallback:
//                                            (bool buildFirstCallback) {
//                                          if (buildFirstCallback == false) {
//                                            buildFirst = false;
//                                          }
//                                        },
                                              buildFirst: buildUnDetailFirst,
                                            )
                                          : (photoNumber == 5)
                                              ? Swipe(
                                                  prof: _prof5(),
                                                  profDetail: _profDetail5(),
                                                  swipeDirection:
                                                      _swipeDirection(),
                                                  swipeUpdate:
                                                      _calculateBackCardSize,
                                                  showingPlaceUpdate:
                                                      _decisionIndicatorUpdate,
                                                  swipeComplete: _swipeComplete,
                                                  detail: detail,
                                                  photoNumber: photoNumber,
                                                  photoCount: photoCount,
                                                  photoNumberCallback: (int
                                                      photoNumberCallback) {
                                                    setState(() {
                                                      photoNumber =
                                                          photoNumberCallback;
                                                      print(
                                                          'photoNumberNext: $photoNumber');
                                                    });
                                                  },
//                                            buildFirstCallback:
//                                                (bool buildFirstCallback) {
//                                              if (buildFirstCallback == false) {
//                                                buildFirst = false;
//                                              }
//                                            },
                                                  buildFirst:
                                                      buildUnDetailFirst,
                                                )
                                              : Swipe(
                                                  prof: _prof6(),
                                                  profDetail: _profDetail6(),
                                                  swipeDirection:
                                                      _swipeDirection(),
                                                  swipeUpdate:
                                                      _calculateBackCardSize,
                                                  showingPlaceUpdate:
                                                      _decisionIndicatorUpdate,
                                                  swipeComplete: _swipeComplete,
                                                  detail: detail,
                                                  photoNumber: photoNumber,
                                                  photoCount: photoCount,
                                                  photoNumberCallback: (int
                                                      photoNumberCallback) {
                                                    setState(() {
                                                      photoNumber =
                                                          photoNumberCallback;
                                                      print(
                                                          'photoNumberNext: $photoNumber');
                                                    });
                                                  },
//                                            buildFirstCallback:
//                                                (bool buildFirstCallback) {
//                                              if (buildFirstCallback == false) {
//                                                buildFirst = false;
//                                              }
//                                            },
                                                  buildFirst:
                                                      buildUnDetailFirst,
                                                ),
                        ])
                      : (searchUserCount == widget.searchUserListLength - 2)
                          ? Stack(
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    '探しています',
                                    style: TextStyle(
                                      color: black87,
                                      fontSize: size.width * 0.045,
                                    ),
                                  ),
                                ),
                                (photoNumber == 1)
                                    ? Swipe(
                                        prof: _prof1(),
                                        profDetail:
                                            _profDetail1(), //特別。2～とは少し違う
                                        swipeDirection: _swipeDirection(),
                                        swipeUpdate: _calculateBackCardSize,
                                        showingPlaceUpdate:
                                            _decisionIndicatorUpdate,
                                        swipeComplete: _swipeComplete,
                                        detail: detail,
                                        photoNumber: photoNumber,
                                        photoCount: photoCount,
                                        photoNumberCallback:
                                            (int photoNumberCallback) {
                                          setState(() {
                                            photoNumber = photoNumberCallback;
                                            print(
                                                'photoNumberNext: $photoNumber');
                                          });
                                        },
//                            buildFirstCallback: (bool buildFirstCallback) {
//                              if (buildFirstCallback == false) {
//                                buildFirst = false;
//                              }
//                            },
                                        buildFirst: buildUnDetailFirst,
                                      )
                                    : (photoNumber == 2)
                                        ? Swipe(
                                            prof: _prof2(),
                                            profDetail: _profDetail2(),
                                            swipeDirection: _swipeDirection(),
                                            swipeUpdate: _calculateBackCardSize,
                                            showingPlaceUpdate:
                                                _decisionIndicatorUpdate,
                                            swipeComplete: _swipeComplete,
                                            detail: detail,
                                            photoNumber: photoNumber,
                                            photoCount: photoCount,
                                            photoNumberCallback:
                                                (int photoNumberCallback) {
                                              setState(() {
                                                photoNumber =
                                                    photoNumberCallback;
                                                print(
                                                    'photoNumberNext: $photoNumber');
                                              });
                                            },
//                                buildFirstCallback: (bool buildFirstCallback) {
//                                  if (buildFirstCallback == false) {
//                                    buildFirst = false;
//                                  }
//                                },
                                            buildFirst: buildUnDetailFirst,
                                          )
                                        : (photoNumber == 3)
                                            ? Swipe(
                                                prof: _prof3(),
                                                profDetail: _profDetail3(),
                                                swipeDirection:
                                                    _swipeDirection(),
                                                swipeUpdate:
                                                    _calculateBackCardSize,
                                                showingPlaceUpdate:
                                                    _decisionIndicatorUpdate,
                                                swipeComplete: _swipeComplete,
                                                detail: detail,
                                                photoNumber: photoNumber,
                                                photoCount: photoCount,
                                                photoNumberCallback:
                                                    (int photoNumberCallback) {
                                                  setState(() {
                                                    photoNumber =
                                                        photoNumberCallback;
                                                    print(
                                                        'photoNumberNext: $photoNumber');
                                                  });
                                                },
//                                    buildFirstCallback:
//                                        (bool buildFirstCallback) {
//                                      if (buildFirstCallback == false) {
//                                        buildFirst = false;
//                                      }
//                                    },
                                                buildFirst: buildUnDetailFirst,
                                              )
                                            : (photoNumber == 4)
                                                ? Swipe(
                                                    prof: _prof4(),
                                                    profDetail: _profDetail4(),
                                                    swipeDirection:
                                                        _swipeDirection(),
                                                    swipeUpdate:
                                                        _calculateBackCardSize,
                                                    showingPlaceUpdate:
                                                        _decisionIndicatorUpdate,
                                                    swipeComplete:
                                                        _swipeComplete,
                                                    detail: detail,
                                                    photoNumber: photoNumber,
                                                    photoCount: photoCount,
                                                    photoNumberCallback: (int
                                                        photoNumberCallback) {
                                                      setState(() {
                                                        photoNumber =
                                                            photoNumberCallback;
                                                        print(
                                                            'photoNumberNext: $photoNumber');
                                                      });
                                                    },
//                                        buildFirstCallback:
//                                            (bool buildFirstCallback) {
//                                          if (buildFirstCallback == false) {
//                                            buildFirst = false;
//                                          }
//                                        },
                                                    buildFirst:
                                                        buildUnDetailFirst,
                                                  )
                                                : (photoNumber == 5)
                                                    ? Swipe(
                                                        prof: _prof5(),
                                                        profDetail:
                                                            _profDetail5(),
                                                        swipeDirection:
                                                            _swipeDirection(),
                                                        swipeUpdate:
                                                            _calculateBackCardSize,
                                                        showingPlaceUpdate:
                                                            _decisionIndicatorUpdate,
                                                        swipeComplete:
                                                            _swipeComplete,
                                                        detail: detail,
                                                        photoNumber:
                                                            photoNumber,
                                                        photoCount: photoCount,
                                                        photoNumberCallback: (int
                                                            photoNumberCallback) {
                                                          setState(() {
                                                            photoNumber =
                                                                photoNumberCallback;
                                                            print(
                                                                'photoNumberNext: $photoNumber');
                                                          });
                                                        },
//                                            buildFirstCallback:
//                                                (bool buildFirstCallback) {
//                                              if (buildFirstCallback == false) {
//                                                buildFirst = false;
//                                              }
//                                            },
                                                        buildFirst:
                                                            buildUnDetailFirst,
                                                      )
                                                    : Swipe(
                                                        prof: _prof6(),
                                                        profDetail:
                                                            _profDetail6(),
                                                        swipeDirection:
                                                            _swipeDirection(),
                                                        swipeUpdate:
                                                            _calculateBackCardSize,
                                                        showingPlaceUpdate:
                                                            _decisionIndicatorUpdate,
                                                        swipeComplete:
                                                            _swipeComplete,
                                                        detail: detail,
                                                        photoNumber:
                                                            photoNumber,
                                                        photoCount: photoCount,
                                                        photoNumberCallback: (int
                                                            photoNumberCallback) {
                                                          setState(() {
                                                            photoNumber =
                                                                photoNumberCallback;
                                                            print(
                                                                'photoNumberNext: $photoNumber');
                                                          });
                                                        },
//                                            buildFirstCallback:
//                                                (bool buildFirstCallback) {
//                                              if (buildFirstCallback == false) {
//                                                buildFirst = false;
//                                              }
//                                            },
                                                        buildFirst:
                                                            buildUnDetailFirst,
                                                      ),
                              ],
                            )
                          : Center(
                              child: Text(
                                '探しています',
                                style: TextStyle(
                                  color: black87,
                                  fontSize: size.width * 0.045,
                                ),
                              ),
                            ),
    );
  }

  void _goNextProf() {
    //前の人更新
    setState(() {
      if (_currentSearch != null) {
        _currentSearch.removeListener(_setState);
      }
      _currentSearch = widget.profIndex.currentProf;
      _nextSearch = widget.profIndex.nextProf;
      if (_currentSearch != null) {
//        searchUserCount = searchUserCount + 1;
        _currentSearch.addListener(_setState);
        photoNumber = 1;
        photoCount = 0;
        if (widget.profIndex.currentProf.selectedUser.photo1 != null &&
            widget.profIndex.currentProf.selectedUser.photo1 != '') {
          photoCount++;
        }
        if (widget.profIndex.currentProf.selectedUser.photo2 != null &&
            widget.profIndex.currentProf.selectedUser.photo2 != '') {
          photoCount++;
        }
        if (widget.profIndex.currentProf.selectedUser.photo3 != null &&
            widget.profIndex.currentProf.selectedUser.photo3 != '') {
          photoCount++;
        }
        if (widget.profIndex.currentProf.selectedUser.photo4 != null &&
            widget.profIndex.currentProf.selectedUser.photo4 != '') {
          photoCount++;
        }
        if (widget.profIndex.currentProf.selectedUser.photo5 != null &&
            widget.profIndex.currentProf.selectedUser.photo5 != '') {
          photoCount++;
        }
        if (widget.profIndex.currentProf.selectedUser.photo6 != null &&
            widget.profIndex.currentProf.selectedUser.photo6 != '') {
          photoCount++;
        }
      }
//      if (searchUserCount > widget.searchUserListLength - 3) {
      if (searchUserCount > widget.searchUserListLength - 2 &&
          match == false &&
          subscriptionInvitation == false) {
//      if (searchUserCount > widget.searchUserListLength - 3 && match == false) {
//        print('matchNameBack: $matchNameHere');
        widget.updateCallback(true);
//        Navigator.of(context).pushReplacement(
//          MaterialPageRoute(
//            builder: (context) {
//              return HomeTab(
//                userFB: widget.userFB,
//                currentUser: widget.currentUser,
//              );
//            },
//          ),
//        );
      }

      _frontProfKey = Key(_currentSearch.selectedUser.uid);
      _backProfKey = Key(_nextSearch.selectedUser.uid);
    });
  }

  void _setState() {
    setState(() {});
  }

  Widget _prof1() {
//    return ProfileCardDetail(
    return Prof1AndBack(
      // 特別。2とかと違う。気を付ける。　detail1も距離消えるの？
      key: _frontProfKey,
//        update: true,
      distanceFront: distanceFront,
      currentUser: widget.currentUser,
      searchUser: widget.profIndex.currentProf.selectedUser,
      swipeDecision: widget.profIndex.currentProf.swipeDecision,
      showingDecision: decisionIndicator,
      isDraggable: true,
//        callback: (String decision) {
//          setState(() {
//            buttonDecision = decision;
//            print('buttonDecision: $buttonDecision');
//          });
//        }
    );
  }

  Widget _prof2() {
    return Prof2(
      key: _frontProfKey,
      distanceFront: distanceFront,
      currentUser: widget.currentUser,
      searchUser: widget.profIndex.currentProf.selectedUser,
      swipeDecision: widget.profIndex.currentProf.swipeDecision,
      showingDecision: decisionIndicator,
      isDraggable: true,
//        callback: (String decision) {
//          setState(() {
//            buttonDecision = decision;
//            print('buttonDecision: $buttonDecision');
//          }
//          );
//        }
    );
  }

  Widget _prof3() {
    return Prof3(
      key: _frontProfKey,
      distanceFront: distanceFront,
      currentUser: widget.currentUser,
      searchUser: widget.profIndex.currentProf.selectedUser,
      swipeDecision: widget.profIndex.currentProf.swipeDecision,
      showingDecision: decisionIndicator,
      isDraggable: true,
//        callback: (String decision) {
//          setState(() {
//            buttonDecision = decision;
//            print('buttonDecision: $buttonDecision');
//          });
//        }
    );
  }

  Widget _prof4() {
    return Prof4(
      key: _frontProfKey,
      distanceFront: distanceFront,
      currentUser: widget.currentUser,
      searchUser: widget.profIndex.currentProf.selectedUser,
      swipeDecision: widget.profIndex.currentProf.swipeDecision,
      showingDecision: decisionIndicator,
      isDraggable: true,
//        callback: (String decision) {
//          setState(() {
//            buttonDecision = decision;
//            print('buttonDecision: $buttonDecision');
//          });
//          }
    );
  }

  Widget _prof5() {
    return Prof5(
      key: _frontProfKey,
      distanceFront: distanceFront,
      currentUser: widget.currentUser,
      searchUser: widget.profIndex.currentProf.selectedUser,
      swipeDecision: widget.profIndex.currentProf.swipeDecision,
      showingDecision: decisionIndicator,
      isDraggable: true,
//        callback: (String decision) {
//          setState(() {
//            buttonDecision = decision;
//            print('buttonDecision: $buttonDecision');
//          });
//        }
    );
  }

  Widget _prof6() {
    return Prof6(
      key: _frontProfKey,
      distanceFront: distanceFront,
      currentUser: widget.currentUser,
      searchUser: widget.profIndex.currentProf.selectedUser,
      swipeDecision: widget.profIndex.currentProf.swipeDecision,
      showingDecision: decisionIndicator,
      isDraggable: true,
//        callback: (String decision) {
//          setState(() {
//            buttonDecision = decision;
//            print('buttonDecision: $buttonDecision');
//          });
//        }
    );
  }

  Widget _profDetail1() {
    return ProfDetail(
      key: _frontProfKey,
      distanceFront: distanceFront,
      currentUser: widget.currentUser,
      searchUser: widget.profIndex.currentProf.selectedUser,
      swipeDecision: widget.profIndex.currentProf.swipeDecision,
      showingDecision: decisionIndicator,
      isDraggable: true,
//      update: widget.update,
      photoNumber: photoNumber,
      photoCount: photoCount,
      photoNumberCallback: (int photoNumberCallback) {
        setState(() {
          photoNumber = photoNumberCallback;
          detail = true;
          print('photoNumberNext: $photoNumber');
        });
      },
      callback: (String decision) {
        setState(() {
//          buttonDecision = decision;
          detail = false;
          buildUnDetailFirst = true;
//          print('buttonDecision: $buttonDecision');
          getDistance(widget.profIndex.currentProf.selectedUser.location);
        });
      },
      detailCallback: (bool detailCallBack) {
        if (detailCallBack == false) {
          setState(() {
            detail = false;
            buildUnDetailFirst = true;
          });
        }
      },
    );
  }

  Widget _profDetail2() {
//    return ProfileCardDetail(
    return ProfDetail2(
        key: _frontProfKey,
        distanceFront: distanceFront,
        currentUser: widget.currentUser,
        searchUser: widget.profIndex.currentProf.selectedUser,
        swipeDecision: widget.profIndex.currentProf.swipeDecision,
        showingDecision: decisionIndicator,
        isDraggable: true,
//        update: widget.update,
        photoNumber: photoNumber,
        photoCount: photoCount,
        photoNumberCallback: (int photoNumberCallback) {
          setState(() {
            photoNumber = photoNumberCallback;
            detail = true;
            print('photoNumberNext: $photoNumber');
          });
        },
        callback: (String decision) {
          setState(() {
//            buttonDecision = decision;
            detail = false;
            buildUnDetailFirst = true;
//            print('buttonDecision: $buttonDecision');
          });
        },
        detailCallback: (bool detailCallBack) {
          if (detailCallBack == false) {
            setState(() {
              detail = false;
              buildUnDetailFirst = true;
            });
          }
        });
  }

  Widget _profDetail3() {
    return ProfDetail3(
        key: _frontProfKey,
        distanceFront: distanceFront,
        currentUser: widget.currentUser,
        searchUser: widget.profIndex.currentProf.selectedUser,
        swipeDecision: widget.profIndex.currentProf.swipeDecision,
        showingDecision: decisionIndicator,
        isDraggable: true,
//        update: widget.update,
        photoNumber: photoNumber,
        photoCount: photoCount,
        photoNumberCallback: (int photoNumberCallback) {
          setState(() {
            photoNumber = photoNumberCallback;
            detail = true;
            print('photoNumberNext: $photoNumber');
          });
        },
        callback: (String decision) {
          setState(() {
//            buttonDecision = decision;
            detail = false;
            buildUnDetailFirst = true;
//            print('buttonDecision: $buttonDecision');
          });
        },
        detailCallback: (bool detailCallBack) {
          if (detailCallBack == false) {
            setState(() {
              detail = false;
              buildUnDetailFirst = true;
            });
          }
        });
  }

  Widget _profDetail4() {
    return ProfDetail4(
        key: _frontProfKey,
        distanceFront: distanceFront,
        currentUser: widget.currentUser,
        searchUser: widget.profIndex.currentProf.selectedUser,
        swipeDecision: widget.profIndex.currentProf.swipeDecision,
        showingDecision: decisionIndicator,
        isDraggable: true,
//        update: widget.update,
        photoNumber: photoNumber,
        photoCount: photoCount,
        photoNumberCallback: (int photoNumberCallback) {
          setState(() {
            photoNumber = photoNumberCallback;
            detail = true;
            print('photoNumberNext: $photoNumber');
          });
        },
        callback: (String decision) {
          setState(() {
//            buttonDecision = decision;
            detail = false;
            buildUnDetailFirst = true;
//            print('buttonDecision: $buttonDecision');
          });
        },
        detailCallback: (bool detailCallBack) {
          if (detailCallBack == false) {
            setState(() {
              detail = false;
              buildUnDetailFirst = true;
            });
          }
        });
  }

  Widget _profDetail5() {
    return ProfDetail5(
        key: _frontProfKey,
        distanceFront: distanceFront,
        currentUser: widget.currentUser,
        searchUser: widget.profIndex.currentProf.selectedUser,
        swipeDecision: widget.profIndex.currentProf.swipeDecision,
        showingDecision: decisionIndicator,
        isDraggable: true,
//        update: widget.update,
        photoNumber: photoNumber,
        photoCount: photoCount,
        photoNumberCallback: (int photoNumberCallback) {
          setState(() {
            photoNumber = photoNumberCallback;
            detail = true;
            print('photoNumberNext: $photoNumber');
          });
        },
        callback: (String decision) {
          setState(() {
//            buttonDecision = decision;
            detail = false;
            buildUnDetailFirst = true;
//            print('buttonDecision: $buttonDecision');
          });
        },
        detailCallback: (bool detailCallBack) {
          if (detailCallBack == false) {
            setState(() {
              detail = false;
              buildUnDetailFirst = true;
            });
          }
        });
  }

  Widget _profDetail6() {
    return ProfDetail6(
        key: _frontProfKey,
        distanceFront: distanceFront,
        currentUser: widget.currentUser,
        searchUser: widget.profIndex.currentProf.selectedUser,
        swipeDecision: widget.profIndex.currentProf.swipeDecision,
        showingDecision: decisionIndicator,
        isDraggable: true,
//        update: widget.update,
        photoNumber: photoNumber,
        photoCount: photoCount,
        photoNumberCallback: (int photoNumberCallback) {
          setState(() {
            photoNumber = photoNumberCallback;
            print('photoNumberNext: $photoNumber');
            detail = true;
          });
        },
        callback: (String decision) {
          setState(() {
//            print('buttonDecision: $buttonDecision');
//            buttonDecision = decision;
            detail = false;
            buildUnDetailFirst = true;
          });
        },
        detailCallback: (bool detailCallBack) {
//          if (detailCallBack != null) {
          //TODO
          if (detailCallBack == false) {
            setState(() {
              detail = false;
              buildUnDetailFirst = true;
            });
          }
//          }
        });
  }

  Widget _profBack() {
    return Transform(
      //backのカードfrontの動きに合わせて動くやつ
      transform: Matrix4.identity()..scale(_nextProfSize, _nextProfSize),
      alignment: Alignment.center,
      child: Prof1AndBack(
        key: _backProfKey,
        currentUser: widget.currentUser,
        searchUser: widget.profIndex.nextProf.selectedUser,
        swipeDecision: widget.profIndex.nextProf.swipeDecision,
        showingDecision: decisionIndicator,
        isDraggable: false,
//        update: widget.update,
      ),
    );
  }

  Widget _showSubscriptionInvitation() {
    String imageUrl;
    if (web) {
      imageUrl = widget.profIndex.currentProf.selectedUser.photo1;
      ui.platformViewRegistry.registerViewFactory(
        imageUrl,
        (int _) => html.ImageElement()..src = imageUrl,
      );
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 5.0,
                spreadRadius: 2.0)
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Material(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              (web)
                  ? HtmlElementView(
                      viewType: imageUrl,
                    )
                  : ShowImageFromURL(
                      photoURL:
                          widget.profIndex.currentProf.selectedUser.photo1,
                    ),
              Container(
                color: white.withAlpha(150),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                    ),
                    child: Column(
                      children: <Widget>[
//                      Text(
//                          'Starsプレミアムを購入'),
                        SizedBox(
                          height: size.height * 0.23,
                        ),
                        Text(
                          'キャンペーン中、スワイプできるカードは1日20枚・LIKEは1日10回・SUPER LIKEは1日1回までです。',
                          style: TextStyle(
                            color: pink,
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.07,
                        ),
                        SizedBox(
                          height: size.height * 0.15,
                        ),
//                      ClipRRect(
//                borderRadius: BorderRadius.circular(size.width * 0.15),
//                        child: Container(
//                          height: size.height * 0.3,
//                          width: size.height * 0.3,
//                          child: ShowImageFromURL(
//                            photoURL:
//                            widget.profIndex.beforeProf.searchUser.photo1,
//                          ),
//                        ),
//                      ),
                        FlatButton(
                          child: Text(
                            'もどる',
                            style: TextStyle(
                              color: pink,
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              subscriptionInvitation = false;
                            });
                            if (searchUserCount >
                                widget.searchUserListLength - 2) {
//                  if (searchUserCount > widget.searchUserListLength - 3) {
                              widget.updateCallback(true);
//                              Navigator.of(context).pushReplacement(
//                                MaterialPageRoute(
//                                  builder: (context) {
//                                    return HomeTab(
//                                      userFB: widget.userFB,
//                                      currentUser: widget.currentUser,
//                                    );
//                                  },
//                                ),
//                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notifyMatch() {
    String imageUrl;
    if (web) {
      imageUrl = widget.profIndex.beforeProf.selectedUser.photo1;
      ui.platformViewRegistry.registerViewFactory(
        imageUrl,
        (int _) => html.ImageElement()..src = imageUrl,
      );
    }
    print('_buildItsAMatchCard');
    print('ItsAMatch decision: ${widget.profIndex.currentProf.swipeDecision}');

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 5.0,
                spreadRadius: 2.0)
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Material(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              (web)
                  ? HtmlElementView(
                      viewType: imageUrl,
                    )
                  : ShowImageFromURL(
                      photoURL: widget.profIndex.beforeProf.selectedUser.photo1,
                    ),
              Container(
                color: white.withAlpha(150),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Transform.rotate(
                        angle: 270.0,
                        child: Text(
                          'Match!!',
                          style: TextStyle(
                            color: pink,
                            fontSize: size.width * 0.25,
                            fontFamily: 'DancingScript',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(size.width * 0.15),
                        child: Container(
                          height: size.width * 0.5,
                          width: size.width * 0.5,
                          child: (web)
                              ? HtmlElementView(
                                  viewType: imageUrl,
                                )
                              : ShowImageFromURL(
                                  photoURL: widget
                                      .profIndex.beforeProf.selectedUser.photo1,
                                ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      FlatButton(
                        child: Text(
                          'スワイプを続ける',
                          style: TextStyle(
                            color: pink,
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          print('next');
                          setState(() {
                            match = false;
                          });
                          if (searchUserCount >
                              widget.searchUserListLength - 2) {
//                  if (searchUserCount > widget.searchUserListLength - 3) {
//                            Navigator.of(context).pushReplacement(
//                              MaterialPageRoute(
//                                builder: (context) {
//                                  return HomeTab(
//                                    userFB: widget.userFB,
//                                    currentUser: widget.currentUser,
//                                  );
//                                },
//                              ),
//                            );
                            widget.updateCallback(true);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _calculateBackCardSize(double distance) {
    setState(() {
      _nextProfSize = 0.9 + (0.08 * (distance / 100)).clamp(0.0, 0.1);
    });
  }

  void _decisionIndicatorUpdate(DecisionIndicator indicator) {
    setState(() {
      decisionIndicator = indicator;
    });
  }

  void _swipeComplete(SwipeDirection direction) {
    print('direction: $direction');
    Decision currentMatch = widget.profIndex.currentProf;

    if (widget.currentUser.lastCardTime.toDate().year != DateTime.now().year ||
        widget.currentUser.lastCardTime.toDate().month !=
            DateTime.now().month ||
        widget.currentUser.lastCardTime.toDate().day != DateTime.now().day) {
      cardCountToday = 1;
      widget.currentUser.lastCardTime = Timestamp.fromDate(DateTime.now());
    } else if (cardCountToday == null) {
      cardCountToday = widget.currentUser.cardCountToday + 1;
    }
//    if (cardCountList[1].year != DateTime
//        .now()
//        .year || cardCountList[1].month != DateTime
//        .now()
//        .month || cardCountList[1].day != DateTime
//        .now()
//        .day) {
//      cardCount = 1;
//    }
//    else if (cardCount == null) {
//      cardCount = cardCountList[0] + 1;
//    }
    else {
      cardCountToday = cardCountToday + 1;
    }
    print('cardCountToday: $cardCountToday');

    if (cardCountToday > 20) {
      setState(() {
        subscriptionInvitation = true;
        cardCountToday = cardCountToday - 1;
      });
    } else if (direction == SwipeDirection.left) {
//    else if (direction == SwipeDirection.left || buttonDecision == 'skip') {
      widget.searchFB.skip(
        currentUserId: widget.currentUser.uid,
        selectedUserId: widget.profIndex.currentProf.selectedUser.uid,
        cardCountToday: cardCountToday,
        selectedUserDecision:
            widget.profIndex.currentProf.selectedUser.decision,
      );
      currentMatch.skip();
      searchUserCount = searchUserCount + 1;
      widget.profIndex.nextIndex();
    } else if (direction == SwipeDirection.right) {
//    else if (direction == SwipeDirection.right || buttonDecision == 'like') {
      if (widget.currentUser.lastLikeTime.toDate().year !=
              DateTime.now().year ||
          widget.currentUser.lastLikeTime.toDate().month !=
              DateTime.now().month ||
          widget.currentUser.lastLikeTime.toDate().day != DateTime.now().day) {
        likeCountToday = 1;
        widget.currentUser.lastLikeTime = Timestamp.fromDate(DateTime.now());
      } else if (likeCountToday == null) {
        likeCountToday = widget.currentUser.likeCountToday + 1;
      }
//      if (cardCountList[3].year != DateTime
//          .now()
//          .year || cardCountList[3].month != DateTime
//          .now()
//          .month || cardCountList[3].day != DateTime
//          .now()
//          .day) {
//        likeCount = 1;
//      }
//      else if (likeCount == null) {
//        likeCount = cardCountList[2] + 1;
//      }
      else {
        likeCountToday = likeCountToday + 1;
      }

      if (likeCountToday > 10) {
        setState(() {
          subscriptionInvitation = true;
          cardCountToday = cardCountToday - 1;
        });
      } else {
        if (widget.profIndex.currentProf.selectedUser.decision == 'like' ||
            widget.profIndex.currentProf.selectedUser.decision == 'superLike') {
          print('マッチ！');
          setState(() {
            match = true;
          });
          _matchFB.acceptUser(
            currentUser: widget.currentUser,
            selectedUser: widget.profIndex.currentProf.selectedUser,
            currentUserDecision: 'acceptLike',
            selectedUserDecision:
                widget.profIndex.currentProf.selectedUser.decision,
          );
        }
        widget.searchFB.like(
          currentUserId: widget.currentUser.uid,
          currentUserName: widget.currentUser.name,
          currentUserBirthday: widget.currentUser.birthday,
          currentUserPhotoURL: widget.currentUser.photo1,
          selectedUserId: widget.profIndex.currentProf.selectedUser.uid,
          selectedUserName: widget.profIndex.currentProf.selectedUser.name,
          selectedUserToken: widget.profIndex.currentProf.selectedUser.token,
          selectedUserEmail: widget.profIndex.currentProf.selectedUser.email,
          cardCountToday: cardCountToday,
          likeCountToday: likeCountToday,
        );
        currentMatch.like();
        searchUserCount = searchUserCount + 1;
        widget.profIndex.nextIndex();
      }
    } else if (direction == SwipeDirection.up) {
//    else if (direction == SwipeDirection.up || buttonDecision == 'superLike') {
      if (widget.currentUser.lastSuperLikeTime.toDate().year !=
              DateTime.now().year ||
          widget.currentUser.lastSuperLikeTime.toDate().month !=
              DateTime.now().month ||
          widget.currentUser.lastSuperLikeTime.toDate().day !=
              DateTime.now().day) {
        superLikeCountToday = 1;
        widget.currentUser.lastSuperLikeTime =
            Timestamp.fromDate(DateTime.now());
      } else if (superLikeCountToday == null) {
        superLikeCountToday = widget.currentUser.superLikeCountToday + 1;
      } else {
        superLikeCountToday = superLikeCountToday + 1;
      }

      if (superLikeCountToday > 1) {
        setState(() {
          subscriptionInvitation = true;
          cardCountToday = cardCountToday - 1;
        });
      } else {
        if (widget.profIndex.currentProf.selectedUser.decision == 'like' ||
            widget.profIndex.currentProf.selectedUser.decision == 'superLike') {
          print('マッチ！');
          setState(() {
            match = true;
          });
          _matchFB.acceptUser(
            currentUser: widget.currentUser,
            selectedUser: widget.profIndex.currentProf.selectedUser,
            currentUserDecision: 'acceptSuperLike',
            selectedUserDecision:
                widget.profIndex.currentProf.selectedUser.decision,
          );
        }

        widget.searchFB.superLike(
          currentUserId: widget.currentUser.uid,
          currentUserName: widget.currentUser.name,
          currentUserBirthday: widget.currentUser.birthday,
          currentUserPhotoURL: widget.currentUser.photo1,
          selectedUserId: widget.profIndex.currentProf.selectedUser.uid,
          selectedUserName: widget.profIndex.currentProf.selectedUser.name,
          selectedUserToken: widget.profIndex.currentProf.selectedUser.token,
          selectedUserEmail: widget.profIndex.currentProf.selectedUser.email,
          cardCountToday: cardCountToday,
          superLikeCountToday: superLikeCountToday,
        );

        currentMatch.superLike();
        searchUserCount = searchUserCount + 1;
        print('nextindex');
        widget.profIndex.nextIndex();
      }
    }

//    else if (buttonDecision == 'undo') {//いつかundoがんばって(まあそんな、いらんやろ)
//      print('undo oo');
//
//      searchUserCount = searchUserCount - 1;
//      widget.Engine.beforeMatch.resetMatch();
//      widget.matchEngine.undoMatch();
//      widget.matchEngine.cycleMatch();
//    }

    if ((match == false) &&
        (searchUserCount > widget.searchUserListLength - 2)) {
//      Navigator.of(context).pushReplacement(
//        MaterialPageRoute(
//          builder: (context) {
//            return HomeTab(
//              userFB: widget.userFB,
//              currentUser: widget.currentUser,
//            );
//          },
//        ),
//      );
      widget.updateCallback(true);
    }
//    print('nextindex');
//    widget.profIndex.nextIndex();
    //ボタンに連続でおせなくなる
  }

  void _swipeCompleteNotifyMatch(SwipeDirection direction) {
    setState(() {
      widget.profIndex.currentProf.undecided();
      match = false;
    });
    if (searchUserCount > widget.searchUserListLength - 2) {
//                  if (searchUserCount > widget.searchUserListLength - 3) {
//      Navigator.of(context).pushReplacement(
//        MaterialPageRoute(
//          builder: (context) {
//            return HomeTab(
//              userFB: widget.userFB,
//              currentUser: widget.currentUser,
//            );
//          },
//        ),
//      );
      widget.updateCallback(true);
    }
  }

  void _swipeCompleteNotifyInvitation(SwipeDirection direction) {
    setState(() {
      widget.profIndex.currentProf.undecided();
      subscriptionInvitation = false;
    });
    if (searchUserCount > widget.searchUserListLength - 2) {
//                  if (searchUserCount > widget.searchUserListLength - 3) {
//      Navigator.of(context).pushReplacement(
//        MaterialPageRoute(
//          builder: (context) {
//            return HomeTab(
//              userFB: widget.userFB,
//              currentUser: widget.currentUser,
//            );
//          },
//        ),
//      );
      widget.updateCallback(true);
    }
  }

  SwipeDirection _swipeDirection() {
//    if (widget.profIndex.currentProf.swipeDecision == SwipeDecision.skip) {
//      return SwipeDirection.left;}
//    else if (widget.profIndex.currentProf.swipeDecision == SwipeDecision.like) {
//        return SwipeDirection.right;}
//    else if (widget.profIndex.currentProf.swipeDecision == SwipeDecision.superLike) {
//      return SwipeDirection.up;}
//    else
    if (widget.profIndex.currentProf.swipeDecision ==
        SwipeDecision.buttonSkip) {
      widget.profIndex.currentProf.undecided();
      return SwipeDirection.buttonLeft;
    } else if (widget.profIndex.currentProf.swipeDecision ==
        SwipeDecision.buttonLike) {
      widget.profIndex.currentProf.undecided();
      return SwipeDirection.buttonRight;
    } else if (widget.profIndex.currentProf.swipeDecision ==
        SwipeDecision.buttonSuperLike) {
      widget.profIndex.currentProf.undecided();
      return SwipeDirection.buttonUp;
    }

//      case Decision.undo:
//        return SlideDirection.undo;
    else {
      return null;
    }
  }

  getDistance(GeoPoint userLocation) async {
    Position position;
    double location;
    if (userLocation != null) {
      if (android || ios) {
        position = await Geolocator.getLastKnownPosition();
      } else if (web) {
        position = await Geolocator.getCurrentPosition();
      }
      location = Geolocator.distanceBetween(userLocation.latitude,
          userLocation.longitude, position.latitude, position.longitude);
      distanceFront = location.toInt();
      print('distanceFront: $distanceFront');
    }
  }
}
