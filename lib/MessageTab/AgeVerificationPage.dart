import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:Keioboys/MessageTab/MessageTab.dart';
import 'package:Keioboys/Widgets/HomeTab.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Keioboys/FB/MatchFB.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Keioboys/MessageTab/MatchBloc/MatchBloc.dart';
import 'package:Keioboys/MessageTab/MatchBloc/MatchEvent.dart';
import 'package:Keioboys/MessageTab/MatchBloc/MatchState.dart';
import 'package:Keioboys/Widgets/CropImageMobile.dart';
import 'package:Keioboys/Widgets/PickCrop.dart';
import 'package:Keioboys/consts.dart';
import 'package:Keioboys/Widgets/UserData.dart';

class AgeVerificationPage extends StatefulWidget {
  final UserFB _userFB;
  final UserData _currentUser;

  AgeVerificationPage({
    @required UserFB userFB,
    @required UserData currentUser,
  })  : assert(userFB != null),
        _userFB = userFB,
        _currentUser = currentUser;

  @override
  _AgeVerificationPageState createState() => _AgeVerificationPageState();
}

class _AgeVerificationPageState extends State<AgeVerificationPage> {
  File photoMobile;
  Uint8List photoWeb;

//  File getPick;
  UserFB get userFB => widget._userFB;
//  UserData currentUser;
//  final StreamController _streamController = StreamController.broadcast();
  bool loading;
  MatchFB matchFB = MatchFB();
  MatchBloc _matchBloc;

  @override
  void initState() {
//    getCurrentUser();
    _matchBloc = MatchBloc(matchFB: matchFB);
    super.initState();
  }

//  Future getCurrentUser() async {
//    currentUser = await userFB.getCurrentUser(widget._currentUser.uid);
//    _streamController.add(currentUser);
//  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder(
        bloc: _matchBloc,
        builder: (BuildContext context, LikedAndMatchState state) {
          if (state is LoadingState) {
            _matchBloc.add(GetUserEvent(
              currentUserId: widget._currentUser.uid,
            ));
            return Container();
          } else if (state is LoadAgeVerificationState) {
            return StreamBuilder(
                stream: state.ageVerificationSnapshot,
                builder: (context, snapshot) {
                  return (snapshot.data != null)
                      ? Scaffold(
                          appBar:
//                          (snapshot.data['ageVerification'] == true)
//                              ? null
//                              :
                              AppBar(
                            toolbarHeight: 80,
                            title: Text(
                              '年齢確認',
                              style: TextStyle(
                                color: pink,
                              ),
                            ),
                            iconTheme: IconThemeData(
                              color: pink,
                            ),
                            backgroundColor: white,
//                                  elevation: 0,
//                                  automaticallyImplyLeading: false,
                          ),
//                  AppBar(
//                          iconTheme: IconThemeData(
//                            color: pink,
//                          ),
//                          backgroundColor: white,
//                          elevation: 0,
//                          automaticallyImplyLeading: false,
//                        ),
                          body: SafeArea(
                            child: Stack(
                              children: <Widget>[
                                (snapshot.data['ageVerification'] == true)
                                    ? SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: size.width * 0.02,
                                            right: size.width * 0.02,
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: size.height * 0.15,
                                                ),
                                                Text(
                                                  '年齢確認が完了しました。',
                                                  style: TextStyle(
                                                    color: black87,
                                                    fontSize: size.width * 0.05,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: size.width * 0.1,
                                                ),
                                                Text(
                                                  'メッセージ機能をご利用になれます。',
                                                  style: TextStyle(
                                                    color: black87,
                                                    fontSize: size.width * 0.05,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: size.width * 0.1,
                                                ),
                                                Text(
                                                  '前の画面に戻ってください。',
                                                  style: TextStyle(
                                                    color: black87,
                                                    fontSize: size.width * 0.05,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : (snapshot.data['ageVerification'] ==
                                            false)
                                        ? SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: size.width * 0.02,
                                                  right: size.width * 0.02,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                        height:
                                                            size.width * 0.05),
                                                    Text(
                                                      'ご提出された身分証明書が正しくありませんでした。注意事項をよくご確認の上、もう一度身分証明書をご提出ください。',
                                                      style: TextStyle(
                                                        color: pink,
                                                        fontSize:
                                                            size.width * 0.043,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          size.width * 0.037,
                                                    ),
                                                    //提出中くるくる
                                                    Text(
                                                      '運転免許証、国民健康保険被保険者証のほか、官公庁、会社、大学等が発行する身分証明書を使用できます。',
                                                      style: TextStyle(
                                                        color: black87,
                                                        fontSize:
                                                            size.width * 0.043,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          size.width * 0.037,
                                                    ),
                                                    Text(
                                                      '※年齢又は生年月日欄、証明書の名称部分、発行者又は発給者の名称部分が必ず見えるようにしてください。',
                                                      style: TextStyle(
                                                        color: black87,
                                                        fontSize:
                                                            size.width * 0.037,
                                                      ),
                                                    ),
                                                    Text(
                                                      '※年齢確認完了後メッセージを使えるようになります。',
                                                      style: TextStyle(
                                                        color: black87,
                                                        fontSize:
                                                            size.width * 0.037,
                                                      ),
                                                    ),
                                                    Text(
                                                      '※年齢確認は通常24時間以内に完了します。',
                                                      style: TextStyle(
                                                        color: black87,
                                                        fontSize:
                                                            size.width * 0.037,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          size.height * 0.02,
                                                    ),
                                                    Center(
                                                      child: pickCrop(),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          size.height * 0.02,
                                                    ),
                                                    (android)
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                '※トリミングできない場合は',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      black87,
                                                                  fontSize:
                                                                      size.width *
                                                                          0.04,
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                child: Text(
                                                                  'コチラ',
                                                                  style:
                                                                      TextStyle(
                                                                    color: pink,
                                                                    fontSize:
                                                                        size.width *
                                                                            0.04,
                                                                  ),
                                                                ),
                                                                onTap:
                                                                    () async {
                                                                  FilePickerResult
                                                                      result =
                                                                      await FilePicker
                                                                          .platform
                                                                          .pickFiles(
                                                                              type: FileType.image);

                                                                  if (result !=
                                                                      null) {
                                                                    photoMobile =
                                                                        File(result
                                                                            .files
                                                                            .single
                                                                            .path);
                                                                    setState(
                                                                        () {});
                                                                  }

//                                                                  getPick = await FilePicker
//                                                                      .getFile(
//                                                                          type:
//                                                                              FileType.IMAGE);
//                                                                  if (getPick !=
//                                                                      null) {
//                                                                    //pickされたなら
//                                                                    photo =
//                                                                        getPick;
//                                                                    setState(
//                                                                      () {},
//                                                                    );
//                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          )
                                                        : Container(),
                                                    SizedBox(
                                                      height:
                                                          size.height * 0.02,
                                                    ),
                                                    Center(
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          if (photoMobile !=
                                                              null) {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            String _result =
                                                                await userFB
                                                                    .ageVerification(
                                                              photoMobile:
                                                                  photoMobile,
                                                              currentUserId: widget
                                                                  ._currentUser
                                                                  .uid,
                                                            );
                                                            if (_result ==
                                                                'success') {
                                                              setState(() {
                                                                loading = false;
//                                                                snapshot.data[
//                                                                        'ageVerification'] =
//                                                                    null;
//                                                                snapshot.data[
//                                                                        'ageVerification'] =
//                                                                    true;
                                                              });
                                                            } else {
                                                              setState(() {
                                                                loading = false;
                                                              });
                                                              Flushbar(
                                                                message:
                                                                    "しばらくしてからもう一度お試しください。",
                                                                backgroundColor:
                                                                    pink,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                              )..show(context);
                                                            }
                                                          } else {
                                                            Flushbar(
                                                              message:
                                                                  "身分証明書を選択しください。",
                                                              backgroundColor:
                                                                  pink,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          3),
                                                            )..show(context);
                                                          }
                                                        },
                                                        child: Container(
                                                          width:
                                                              size.width * 0.7,
                                                          height:
                                                              size.width * 0.1,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: pink,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "提出",
                                                              style: TextStyle(
                                                                color: white,
                                                                fontSize:
                                                                    size.width *
                                                                        0.06,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          size.height * 0.033,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : (snapshot.data['ageVerification'] ==
                                                    null &&
                                                snapshot.data[
                                                        'ageVerificationPhoto'] !=
                                                    null)
                                            ? SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    left: size.width * 0.02,
                                                    right: size.width * 0.02,
                                                  ),
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: size.height *
                                                              0.15,
                                                        ),
                                                        Text(
                                                          '身分証明書の確認中です。',
                                                          style: TextStyle(
                                                            color: black87,
                                                            fontSize:
                                                                size.width *
                                                                    0.05,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              size.width * 0.1,
                                                        ),
                                                        Text(
                                                          'もうしばらくお待ちください。',
                                                          style: TextStyle(
                                                            color: black87,
                                                            fontSize:
                                                                size.width *
                                                                    0.05,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              size.width * 0.1,
                                                        ),
                                                        Text(
                                                          '年齢確認は通常12時間以内に完了します。',
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
                                                ),
                                              )
                                            : SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    left: size.width * 0.02,
                                                    right: size.width * 0.02,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                          height: size.width *
                                                              0.05),
                                                      Text(
                                                        '年齢確認のため身分証明書を提出してください。',
                                                        style: TextStyle(
                                                          color: black87,
                                                          fontSize: size.width *
                                                              0.043,
                                                        ),
                                                      ),
                                                      //提出中くるくる
                                                      Text(
                                                        '運転免許証・健康保険証・学生証などが使用できます。',
                                                        style: TextStyle(
                                                          color: black87,
                                                          fontSize: size.width *
                                                              0.043,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            size.width * 0.037,
                                                      ),
                                                      Text(
                                                        '※マッチングアプリの年齢確認は法律で義務付けられており、Keioboysは警察署の許認可を得て適切に個人情報を取り扱っています。(登録番号：三田21-098162)',
                                                        style: TextStyle(
                                                          color: black87,
                                                          fontSize: size.width *
                                                              0.037,
                                                        ),
                                                      ),
                                                      Text(
                                                        '※身分証明書は年齢確認の目的のみで使用し、年齢確認完了と同時にデータベースから消去されます。',
                                                        style: TextStyle(
                                                          color: black87,
                                                          fontSize: size.width *
                                                              0.037,
                                                        ),
                                                      ),
//                                                  Text(
//                                                    '※年齢確認完了後メッセージを使えるようになります。',
//                                                    style: TextStyle(
//                                                      color: black87,
//                                                      fontSize:
//                                                          size.width * 0.037,
//                                                    ),
//                                                  ),
//                                                  Text(
//                                                    '※年齢確認は通常12時間以内に完了します。',
//                                                    style: TextStyle(
//                                                      color: black87,
//                                                      fontSize:
//                                                          size.width * 0.037,
//                                                    ),
//                                                  ),
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.033,
                                                      ),
                                                      Center(
                                                        child: pickCrop(),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.03,
                                                      ),
                                                      (android)
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  '※トリミングできない場合は',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        black87,
                                                                    fontSize:
                                                                        size.width *
                                                                            0.04,
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  child: Text(
                                                                    'コチラ',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          pink,
                                                                      fontSize:
                                                                          size.width *
                                                                              0.04,
                                                                    ),
                                                                  ),
                                                                  onTap:
                                                                      () async {
                                                                    FilePickerResult
                                                                        result =
                                                                        await FilePicker
                                                                            .platform
                                                                            .pickFiles(type: FileType.image);

                                                                    if (result !=
                                                                        null) {
                                                                      photoMobile = File(result
                                                                          .files
                                                                          .single
                                                                          .path);
                                                                      setState(
                                                                          () {});
                                                                    }
//                                                                    getPick = await FilePicker
//                                                                        .getFile(
//                                                                            type:
//                                                                                FileType.IMAGE);
//                                                                    if (getPick !=
//                                                                        null) {
//                                                                      //pickされたなら
//                                                                      photo =
//                                                                          getPick;
//                                                                      setState(
//                                                                        () {},
//                                                                      );
//                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            )
                                                          : Container(),
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.03,
                                                      ),
                                                      Center(
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            if (loading =
                                                                true) {
                                                              if (web) {
                                                                if (photoWeb !=
                                                                    null) {
                                                                  setState(() {
                                                                    loading =
                                                                        true;
                                                                  });
                                                                  String
                                                                      _result =
                                                                      await userFB
                                                                          .ageVerification(
                                                                    photoWeb:
                                                                        photoWeb,
                                                                    currentUserId:
                                                                        widget
                                                                            ._currentUser
                                                                            .uid,
                                                                  );
                                                                  if (_result ==
                                                                      'success') {
                                                                    setState(
                                                                        () {
                                                                      loading =
                                                                          false;
                                                                    });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      loading =
                                                                          false;
                                                                    });
                                                                    Flushbar(
                                                                      message:
                                                                          "しばらくしてからもう一度お試しください。",
                                                                      backgroundColor:
                                                                          pink,
                                                                      duration: Duration(
                                                                          seconds:
                                                                              3),
                                                                    )..show(
                                                                        context);
                                                                  }
                                                                } else {
                                                                  Flushbar(
                                                                    message:
                                                                        "身分証明書を選択してください。",
                                                                    backgroundColor:
                                                                        pink,
                                                                    duration: Duration(
                                                                        seconds:
                                                                            3),
                                                                  )..show(
                                                                      context);
                                                                }
                                                              } else if (android ||
                                                                  web) {
                                                                if (photoMobile !=
                                                                    null) {
                                                                  setState(() {
                                                                    loading =
                                                                        true;
                                                                  });
                                                                  String
                                                                      _result =
                                                                      await userFB
                                                                          .ageVerification(
                                                                    photoMobile:
                                                                        photoMobile,
                                                                    currentUserId:
                                                                        widget
                                                                            ._currentUser
                                                                            .uid,
                                                                  );
                                                                  if (_result ==
                                                                      'success') {
                                                                    setState(
                                                                        () {
                                                                      loading =
                                                                          false;
                                                                    });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      loading =
                                                                          false;
                                                                    });
                                                                    Flushbar(
                                                                      message:
                                                                          "しばらくしてからもう一度お試しください。",
                                                                      backgroundColor:
                                                                          pink,
                                                                      duration: Duration(
                                                                          seconds:
                                                                              3),
                                                                    )..show(
                                                                        context);
                                                                  }
                                                                } else {
                                                                  Flushbar(
                                                                    message:
                                                                        "身分証明書を選択してください。",
                                                                    backgroundColor:
                                                                        pink,
                                                                    duration: Duration(
                                                                        seconds:
                                                                            3),
                                                                  )..show(
                                                                      context);
                                                                }
                                                              }
                                                            }
                                                          },
                                                          child: Container(
                                                            width: size.width *
                                                                0.7,
                                                            height: size.width *
                                                                0.1,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: pink,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                "提出",
                                                                style:
                                                                    TextStyle(
                                                                  color: white,
                                                                  fontSize:
                                                                      size.width *
                                                                          0.06,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.033,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                (loading == true)
                                    ? Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation(pink),
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        )
                      :
//          Positioned.fill(
//                  child:
                      Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(pink),
                          ),
//                  ),
                        );
                });
          } else
            return Container();
        });
  }

  Widget pickCrop() {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.width * 0.54,
      width: size.width * 0.856,
      child: GestureDetector(
        onTap: () async {
          if (web) {
            photoWeb = await pickAndCrop(
              context: context,
              mounted: mounted,
              ratio: 2.568 / 1.62,
            );
            setState(() {});
          } else if (android || ios) {
            FilePickerResult result = await FilePicker.platform.pickFiles(
              type: FileType.image,
            );
            if (result != null) {
              File pickMobile = File(result.files.single.path);
              File cropMobile = await cropImageMobile(
                image: pickMobile,
                width: 2.568,
                height: 1.62,
              );
              if (cropMobile != null) {
                photoMobile = cropMobile;
                setState(() {});
              }
            }
          }
        },
        child: (photoMobile != null || photoWeb != null) //pickされたなら
            ? Stack(
                children: <Widget>[
                  Container(
                    height: size.width * 0.54,
                    width: size.width * 0.856,
                    child: (web)
                        ? Image.memory(photoWeb)
                        : Image(
                            fit: BoxFit.cover,
                            image: FileImage(photoMobile),
                          ),
                  ),
                ],
              )
            : Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: white,
                      border: Border.all(
                        width: size.width * 0.005,
                        color: pink,
                      ),
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add_photo_alternate_outlined,
                      color: pink,
                      size: size.width * 0.15,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future cropImageForAgeVerification(File image) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(
        ratioX: 0.856,
        ratioY: 0.54,
      ),
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'トリミング',
        toolbarColor: white,
        toolbarWidgetColor: pink,
        statusBarColor: black,
        activeControlsWidgetColor: pink,
      ),
      iosUiSettings: IOSUiSettings(
        doneButtonTitle: 'OK',
        cancelButtonTitle: 'キャンセル',
        title: 'トリミング',
        resetAspectRatioEnabled: false,
        resetButtonHidden: true,
        rotateButtonsHidden: true,
        rotateClockwiseButtonHidden: true,
      ),
    );
    return croppedImage;
  }
}
