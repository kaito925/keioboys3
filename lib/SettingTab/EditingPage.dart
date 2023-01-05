import 'dart:async';
import 'dart:typed_data';
import 'package:Keioboys/Widgets/fake_ui.dart' if (dart.library.html) 'dart:ui'
    as ui;
import 'package:universal_html/html.dart' as html;
import 'package:Keioboys/Widgets/PickCrop.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:Keioboys/SettingTab/MyProfPage.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:Keioboys/Widgets/CropImageMobile.dart';
import 'package:Keioboys/Widgets/ShowImageFromURL.dart';
import 'package:Keioboys/Widgets/TextFieldEditing.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:Keioboys/consts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Keioboys/Widgets/CircleButton.dart';

class EditingPage extends StatefulWidget {
  final UserData _currentUser;
  final UserFB _userFB;
  final bool _fromEdit;

  EditingPage({
    UserData currentUser,
    UserFB userFB,
    bool noName,
    bool fromEdit,
  })  : assert(currentUser != null),
        _currentUser = currentUser,
        _userFB = userFB,
        _fromEdit = fromEdit;

  @override
  _EditingPageState createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
//  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _profileController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Uint8List photoWeb1;
  Uint8List photoWeb2;
  Uint8List photoWeb3;
  Uint8List photoWeb4;
  Uint8List photoWeb5;
  Uint8List photoWeb6;

  Uint8List cropWeb1;
  Uint8List cropWeb2;
  Uint8List cropWeb3;
  Uint8List cropWeb4;
  Uint8List cropWeb5;
  Uint8List cropWeb6;

  File photoMobile1;
  File photoMobile2;
  File photoMobile3;
  File photoMobile4;
  File photoMobile5;
  File photoMobile6;
//  File photo7;
//  File photo8;
//  File photo9;

  File pickMobile1;
  File pickMobile2;
  File pickMobile3;
  File pickMobile4;
  File pickMobile5;
  File pickMobile6;

//  File getPick7;
//  File getPick8;
//  var getPick9;
  File cropMobile1;
  File cropMobile2;
  File cropMobile3;
  File cropMobile4;
  File cropMobile5;
  File cropMobile6;

  String initWidgetPhoto1;
  String initWidgetPhoto2;
  String initWidgetPhoto3;
  String initWidgetPhoto4;
  String initWidgetPhoto5;
  String initWidgetPhoto6;

  bool loading;
  bool isLoadingWithDialog;
  bool update;
  bool readOnly;

  @override
  void initState() {
    update = false;
    loading = false;
    isLoadingWithDialog = false;
//    _nameController.text = widget._currentUser.name;
    _profileController.text = widget._currentUser.profile;
    _schoolController.text = widget._currentUser.school;
    _companyController.text = widget._currentUser.company;
//    _addressController.text = widget._currentUser.address;

    initWidgetPhoto1 = widget._currentUser.photo1;
    initWidgetPhoto2 = widget._currentUser.photo2;
    initWidgetPhoto3 = widget._currentUser.photo3;
    initWidgetPhoto4 = widget._currentUser.photo4;
    initWidgetPhoto5 = widget._currentUser.photo5;
    initWidgetPhoto6 = widget._currentUser.photo6;
    super.initState();
  }

  @override
  void dispose() {
//    _nameController.dispose();
    _profileController.dispose();
    _schoolController.dispose();
    _companyController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserData _currentUser;

    return WillPopScope(
      //Androidボタンからもどるときも使える
      onWillPop: () async {
        if (_profileController.text == widget._currentUser.profile &&
            _schoolController.text == widget._currentUser.school &&
            _companyController.text == widget._currentUser.company &&
            update == false) {
          if (widget._fromEdit) {
            Navigator.of(context).pop(widget._currentUser); //引数わたしてもどる
            Navigator.of(context).pop(widget._currentUser); //引数わたしてもどる
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return MyProfPage(
                    currentUser: widget._currentUser,
                    userFB: widget._userFB,
                  );
                },
              ),
            );
          } else {
            Navigator.of(context).pop(widget._currentUser); //引数わたしてもどる
          }
          return Future.value(false);
        } else {
          showDialog(
            context: context,
            builder: (_) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return WillPopScope(
                    onWillPop: () {
                      return Future.value(false);
                    },
                    child: Stack(
                      children: <Widget>[
                        AlertDialog(
                          content: Container(
                            width: size.width * 0.9,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  height: size.width * 0.02,
                                ),
                                Text(
                                  '保存せずに終了してもよろしいですか？',
                                  style: TextStyle(
                                    color: black87,
                                    fontSize: size.width * 0.045,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                "保存しない",
                                style: TextStyle(color: black87),
                              ),
                              splashColor: lightGrey,
                              onPressed: () async {
                                _currentUser =
                                    await widget._userFB.getCurrentUser(
                                  widget._currentUser.uid,
                                );
                                FocusScope.of(context).unfocus();
                                Navigator.pop(context);
                                if (widget._fromEdit) {
                                  Navigator.of(context)
                                      .pop(_currentUser); //引数わたしてもどる
                                  Navigator.of(context).pop(_currentUser);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return MyProfPage(
                                          currentUser: _currentUser,
                                          userFB: widget._userFB,
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  Navigator.of(context)
                                      .pop(_currentUser); //引数わたしてもどる
                                }
                              },
                            ),
                            FlatButton(
                              child: Text(
                                "保存",
                                style: TextStyle(color: pink),
                              ),
                              splashColor: lightGrey,
                              onPressed: () async {
                                if (web &&
                                    photoWeb1 == null &&
                                    widget._currentUser.photo1 == null) {
                                  Flushbar(
                                    message: "プロフィール写真を1枚以上登録してください。",
                                    backgroundColor: pink,
                                    duration: Duration(seconds: 3),
                                  )..show(context);
                                  return Future.value(false);
                                } else if ((android || ios) &&
                                    photoMobile1 == null &&
                                    widget._currentUser.photo1 == null) {
                                  Flushbar(
                                    message: "プロフィール写真を1枚以上登録してください。",
                                    backgroundColor: pink,
                                    duration: Duration(seconds: 3),
                                  )..show(context);
                                  return Future.value(false);
                                } else if (_schoolController.text.length > 20) {
                                  Flushbar(
                                    message: "学校は20字以内で入力してください。",
                                    backgroundColor: pink,
                                    duration: Duration(seconds: 3),
                                  )..show(context);
                                  return Future.value(false);
                                } else if (_companyController.text.length >
                                    20) {
                                  Flushbar(
                                    message: "仕事は20字以内で入力してください。",
                                    backgroundColor: pink,
                                    duration: Duration(seconds: 3),
                                  )..show(context);
                                  return Future.value(false);
                                } else if (_schoolController.text.length >
                                    500) {
                                  Flushbar(
                                    message: "プロフィールは500字以内で入力してください。",
                                    backgroundColor: pink,
                                    duration: Duration(seconds: 3),
                                  )..show(context);
                                  return Future.value(false);
                                } else {
                                  setState(() {
                                    isLoadingWithDialog = true;
                                  });
                                  await widget._userFB.updateProfile(
                                    userId: widget._currentUser.uid,
//            widget._currentUser.name,
                                    profile: _profileController.text,
                                    school: _schoolController.text,
                                    company: _companyController.text,
//            _addressController.text,
                                    photoMobile1: photoMobile1,
                                    photoMobile2: photoMobile2,
                                    photoMobile3: photoMobile3,
                                    photoMobile4: photoMobile4,
                                    photoMobile5: photoMobile5,
                                    photoMobile6: photoMobile6,
                                    photoWeb1: photoWeb1,
                                    photoWeb2: photoWeb2,
                                    photoWeb3: photoWeb3,
                                    photoWeb4: photoWeb4,
                                    photoWeb5: photoWeb5,
                                    photoWeb6: photoWeb6,

                                    initWidgetPhoto1: initWidgetPhoto1,
                                    initWidgetPhoto2: initWidgetPhoto2,
                                    initWidgetPhoto3: initWidgetPhoto3,
                                    initWidgetPhoto4: initWidgetPhoto4,
                                    initWidgetPhoto5: initWidgetPhoto5,
                                    initWidgetPhoto6: initWidgetPhoto6,
                                    changedWidgetPhoto1:
                                        widget._currentUser.photo1,
                                    changedWidgetPhoto2:
                                        widget._currentUser.photo2,
                                    changedWidgetPhoto3:
                                        widget._currentUser.photo3,
                                    changedWidgetPhoto4:
                                        widget._currentUser.photo4,
                                    changedWidgetPhoto5:
                                        widget._currentUser.photo5,
                                    changedWidgetPhoto6:
                                        widget._currentUser.photo6,
                                  );
                                  print('プロフィールの変更');
                                  _currentUser =
                                      await widget._userFB.getCurrentUser(
                                    widget._currentUser.uid,
                                  );

                                  FocusScope.of(context).unfocus();
                                  Navigator.pop(context);
                                  if (widget._fromEdit) {
                                    Navigator.of(context)
                                        .pop(_currentUser); //引数わたしてもどる
                                    Navigator.of(context)
                                        .pop(_currentUser); //引数わたしてもどる
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return MyProfPage(
                                            currentUser: _currentUser,
                                            userFB: widget._userFB,
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    Navigator.of(context).pop(_currentUser);
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                        (isLoadingWithDialog)
                            ? Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(pink),
                                  ),
                                ),
                              )
                            : Container(
                                width: 0,
                                height: 0,
                              ),
                      ],
                    ),
                  );
                },
              );
            },
          );
          return Future.value(false);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            brightness: Brightness.light,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'プロフィール編集',
                  style: TextStyle(
                    color: pink,
                  ),
                ),
                (android)
                    ? IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: pink,
//                  size: size.height * 0.035,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return AlertDialog(
                                    content: Container(
                                      width: size.width * 0.9,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          SizedBox(
                                            height: size.width * 0.02,
                                          ),
                                          Text(
                                            "トリミングできない場合はこちらから写真を追加してください。",
                                            style: TextStyle(
                                              color: black87,
                                              fontSize: size.width * 0.05,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          "写真を追加",
                                          style: TextStyle(
                                            color: pink,
                                          ),
                                        ),
                                        splashColor: lightGrey,
                                        onPressed: () async {
                                          FilePickerResult result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                                      type: FileType.image);
                                          if (result != null) {
                                            pickMobile6 =
                                                File(result.files.single.path);

//                                            getPick6 = await FilePicker.getFile(
//                                                type: FileType.IMAGE);
//                                            if (getPick6 != null) {
                                            update = true;
                                            //pickされたなら
                                            if (photoMobile6 != null ||
                                                widget._currentUser.photo6 !=
                                                    null) {
                                              photoMobile6 = pickMobile6;
                                              widget._currentUser.photo6 = null;
                                            } else if (photoMobile1 == null &&
                                                widget._currentUser.photo1 ==
                                                    null) {
                                              photoMobile1 = pickMobile6;
                                            } else if (photoMobile2 == null &&
                                                widget._currentUser.photo2 ==
                                                    null) {
                                              photoMobile2 = pickMobile6;
                                            } else if (photoMobile3 == null &&
                                                widget._currentUser.photo3 ==
                                                    null) {
                                              photoMobile3 = pickMobile6;
                                            } else if (photoMobile4 == null &&
                                                widget._currentUser.photo4 ==
                                                    null) {
                                              photoMobile4 = pickMobile6;
                                            } else if (photoMobile5 == null &&
                                                widget._currentUser.photo5 ==
                                                    null) {
                                              photoMobile5 = pickMobile6;
                                            } else {
                                              photoMobile6 = pickMobile6;
                                            }
                                            setState(() {});
                                          }
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                              });
                        })
                    : Container(),
              ],
            ),
            iconTheme: IconThemeData(
              color: pink,
            ),
            backgroundColor: white,
//            elevation: 0,
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(
                  size.width * 0.015,
                ),
                child: Container(
                  child: (loading)
                      ? Stack(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    pickCrop1(),
                                    SizedBox(
                                      width: size.width * 0.01,
                                    ),
                                    pickCrop2(),
                                    SizedBox(
                                      width: size.width * 0.01,
                                    ),
                                    pickCrop3(),
                                  ],
                                ),
                                SizedBox(
                                  width: size.width * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    pickCrop4(),
                                    SizedBox(
                                      width: size.width * 0.01,
                                    ),
                                    pickCrop5(),
                                    SizedBox(
                                      width: size.width * 0.01,
                                    ),
                                    pickCrop6(),
                                  ],
                                ),
                                SizedBox(
                                  height: size.width * 0.05,
                                ),
                                textFieldEditing(
                                  text: '学校',
                                  readOnly: (widget._currentUser.gender == '男性')
                                      ? true
                                      : (readOnly == true)
                                          ? true
                                          : false,
                                  controller: _schoolController,
                                  size: size,
                                ),
                                SizedBox(
                                  height: size.width * 0.02,
                                ),
                                textFieldEditing(
                                  text: '仕事',
                                  readOnly: (readOnly == true) ? true : false,
                                  controller: _companyController,
                                  size: size,
                                ),
                                SizedBox(
                                  height: size.width * 0.02,
                                ),
                                textFieldProfile(
                                  text: '自己紹介',
                                  readOnly: (readOnly == true) ? true : false,
                                  controller: _profileController,
                                  size: size,
                                ),
                                SizedBox(
                                  height: size.width * 0.02,
                                ),
                                Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (loading != true) {
                                        if (_profileController.text ==
                                                widget._currentUser.profile &&
                                            _schoolController.text ==
                                                widget._currentUser.school &&
                                            _companyController.text ==
                                                widget._currentUser.company &&
                                            update == false) {
                                          if (widget._fromEdit) {
                                            Navigator.of(context).pop(widget
                                                ._currentUser); //引数わたしてもどる
                                            Navigator.of(context).pop(widget
                                                ._currentUser); //引数わたしてもどる
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return MyProfPage(
                                                    currentUser:
                                                        widget._currentUser,
                                                    userFB: widget._userFB,
                                                  );
                                                },
                                              ),
                                            );
                                          } else {
                                            Navigator.of(context).pop(widget
                                                ._currentUser); //引数わたしてもどる
                                          }
                                        } else if (web &&
                                            photoWeb1 == null &&
                                            widget._currentUser.photo1 ==
                                                null) {
                                          Flushbar(
                                            message: "プロフィール写真を1枚以上登録してください。",
                                            backgroundColor: pink,
                                            duration: Duration(seconds: 3),
                                          )..show(context);
                                        } else if ((android || ios) &&
                                            photoMobile1 == null &&
                                            widget._currentUser.photo1 ==
                                                null) {
                                          Flushbar(
                                            message: "プロフィール写真を1枚以上登録してください。",
                                            backgroundColor: pink,
                                            duration: Duration(seconds: 3),
                                          )..show(context);
                                        } else if (_schoolController
                                                .text.length >
                                            20) {
                                          Flushbar(
                                            message: "学校は20字以内で入力してください。",
                                            backgroundColor: pink,
                                            duration: Duration(seconds: 3),
                                          )..show(context);
                                        } else if (_companyController
                                                .text.length >
                                            20) {
                                          Flushbar(
                                            message: "仕事は20字以内で入力してください。",
                                            backgroundColor: pink,
                                            duration: Duration(seconds: 3),
                                          )..show(context);
                                        } else if (_schoolController
                                                .text.length >
                                            500) {
                                          Flushbar(
                                            message: "プロフィールは500字以内で入力してください。",
                                            backgroundColor: pink,
                                            duration: Duration(seconds: 3),
                                          )..show(context);
                                        } else {
                                          setState(() {
                                            loading = true;
                                          });

                                          await widget._userFB.updateProfile(
                                            userId: widget._currentUser.uid,
//            widget._currentUser.name,
                                            profile: _profileController.text,
                                            school: _schoolController.text,
                                            company: _companyController.text,
//            _addressController.text,
                                            photoMobile1: photoMobile1,
                                            photoMobile2: photoMobile2,
                                            photoMobile3: photoMobile3,
                                            photoMobile4: photoMobile4,
                                            photoMobile5: photoMobile5,
                                            photoMobile6: photoMobile6,
                                            photoWeb1: photoWeb1,
                                            photoWeb2: photoWeb2,
                                            photoWeb3: photoWeb3,
                                            photoWeb4: photoWeb4,
                                            photoWeb5: photoWeb5,
                                            photoWeb6: photoWeb6,
                                            initWidgetPhoto1: initWidgetPhoto1,
                                            initWidgetPhoto2: initWidgetPhoto2,
                                            initWidgetPhoto3: initWidgetPhoto3,
                                            initWidgetPhoto4: initWidgetPhoto4,
                                            initWidgetPhoto5: initWidgetPhoto5,
                                            initWidgetPhoto6: initWidgetPhoto6,
                                            changedWidgetPhoto1:
                                                widget._currentUser.photo1,
                                            changedWidgetPhoto2:
                                                widget._currentUser.photo2,
                                            changedWidgetPhoto3:
                                                widget._currentUser.photo3,
                                            changedWidgetPhoto4:
                                                widget._currentUser.photo4,
                                            changedWidgetPhoto5:
                                                widget._currentUser.photo5,
                                            changedWidgetPhoto6:
                                                widget._currentUser.photo6,
                                          );
                                          _currentUser = await widget._userFB
                                              .getCurrentUser(
                                            widget._currentUser.uid,
                                          );
                                          if (widget._fromEdit) {
                                            Navigator.of(context)
                                                .pop(_currentUser); //引数わたしてもどる
                                            Navigator.of(context)
                                                .pop(_currentUser); //引数わたしてもどる
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return MyProfPage(
                                                    currentUser: _currentUser,
                                                    userFB: widget._userFB,
                                                  );
                                                },
                                              ),
                                            );
                                          } else {
                                            Navigator.of(context)
                                                .pop(_currentUser);
                                          }
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: size.width * 0.8,
                                      height: size.height * 0.045,
                                      decoration: BoxDecoration(
                                        color: pink,
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        border: Border.all(
                                          color: pink,
                                          width: size.width * 0.0025,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "保存",
                                          style: TextStyle(
                                            fontSize: size.width * 0.05,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: size.width * 0.06,
                                ),
                              ],
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(pink),
                                ),
                              ),
                            ),
                          ],
                        )
                      :
                      //(noName) ?
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                pickCrop1(),
                                SizedBox(
                                  width: size.width * 0.01,
                                ),
                                pickCrop2(),
                                SizedBox(
                                  width: size.width * 0.01,
                                ),
                                pickCrop3(),
                              ],
                            ),
                            SizedBox(
                              height: size.width * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                pickCrop4(),
                                SizedBox(
                                  width: size.width * 0.01,
                                ),
                                pickCrop5(),
                                SizedBox(
                                  width: size.width * 0.01,
                                ),
                                pickCrop6(),
                              ],
                            ),
//                            Row(
//                              children: <Widget>[
//                                editProfilePhoto7(),
//                                editProfilePhoto8(),
//                                editProfilePhoto9(),
//                              ],
//                            ),
//                            Text('ニックネーム'),
//                            (widget._noName)
//                                ? Text('ニックネームを入力してください')
//                                : Container(),
//                            textFieldEditing('ニックネームを追加', _nameController),
//                            Text('プロフィール'),

                            SizedBox(
                              height: size.width * 0.05,
                            ),
                            textFieldEditing(
                              text: '学校',
                              readOnly: (widget._currentUser.gender == '男性')
                                  ? true
                                  : (readOnly == true)
                                      ? true
                                      : false,
                              controller: _schoolController,
                              size: size,
                            ),
                            SizedBox(
                              height: size.width * 0.02,
                            ),
                            textFieldEditing(
                              text: '仕事',
                              readOnly: (readOnly == true) ? true : false,
                              controller: _companyController,
                              size: size,
                            ),
//                            SizedBox(height: size.height * 0.01),
//                            textFieldEditing(
//                              text: '在住地',
//                              controller: _addressController,
//                              size: size,
//                            ),
                            SizedBox(
                              height: size.width * 0.02,
                            ),
                            textFieldProfile(
                              text: '自己紹介',
                              readOnly: (readOnly == true) ? true : false,
                              controller: _profileController,
                              size: size,
                            ),
                            SizedBox(
                              height: size.width * 0.02,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  if (_profileController.text ==
                                          widget._currentUser.profile &&
                                      _schoolController.text ==
                                          widget._currentUser.school &&
                                      _companyController.text ==
                                          widget._currentUser.company &&
                                      update == false) {
                                    if (widget._fromEdit) {
                                      Navigator.of(context)
                                          .pop(widget._currentUser); //引数わたしてもどる
                                      Navigator.of(context)
                                          .pop(widget._currentUser); //引数わたしてもどる
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return MyProfPage(
                                              currentUser: widget._currentUser,
                                              userFB: widget._userFB,
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      Navigator.of(context)
                                          .pop(widget._currentUser); //引数わたしてもどる
                                    }
                                  } else if (web &&
                                      photoWeb1 == null &&
                                      widget._currentUser.photo1 == null) {
                                    Flushbar(
                                      message: "プロフィール写真を1枚以上登録してください。",
                                      backgroundColor: pink,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  } else if ((android || ios) &&
                                      photoMobile1 == null &&
                                      widget._currentUser.photo1 == null) {
                                    Flushbar(
                                      message: "プロフィール写真を1枚以上登録してください。",
                                      backgroundColor: pink,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  } else if (_schoolController.text.length >
                                      20) {
                                    Flushbar(
                                      message: "学校は20字以内で入力してください。",
                                      backgroundColor: pink,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  } else if (_companyController.text.length >
                                      20) {
                                    Flushbar(
                                      message: "仕事は20字以内で入力してください。",
                                      backgroundColor: pink,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  } else if (_schoolController.text.length >
                                      500) {
                                    Flushbar(
                                      message: "プロフィールは500字以内で入力してください。",
                                      backgroundColor: pink,
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  } else {
                                    setState(() {
                                      loading = true;
                                    });

                                    await widget._userFB.updateProfile(
                                      userId: widget._currentUser.uid,
//            widget._currentUser.name,
                                      profile: _profileController.text,
                                      school: _schoolController.text,
                                      company: _companyController.text,
//            _addressController.text,
                                      photoMobile1: photoMobile1,
                                      photoMobile2: photoMobile2,
                                      photoMobile3: photoMobile3,
                                      photoMobile4: photoMobile4,
                                      photoMobile5: photoMobile5,
                                      photoMobile6: photoMobile6,
                                      photoWeb1: photoWeb1,
                                      photoWeb2: photoWeb2,
                                      photoWeb3: photoWeb3,
                                      photoWeb4: photoWeb4,
                                      photoWeb5: photoWeb5,
                                      photoWeb6: photoWeb6,
                                      initWidgetPhoto1: initWidgetPhoto1,
                                      initWidgetPhoto2: initWidgetPhoto2,
                                      initWidgetPhoto3: initWidgetPhoto3,
                                      initWidgetPhoto4: initWidgetPhoto4,
                                      initWidgetPhoto5: initWidgetPhoto5,
                                      initWidgetPhoto6: initWidgetPhoto6,
                                      changedWidgetPhoto1:
                                          widget._currentUser.photo1,
                                      changedWidgetPhoto2:
                                          widget._currentUser.photo2,
                                      changedWidgetPhoto3:
                                          widget._currentUser.photo3,
                                      changedWidgetPhoto4:
                                          widget._currentUser.photo4,
                                      changedWidgetPhoto5:
                                          widget._currentUser.photo5,
                                      changedWidgetPhoto6:
                                          widget._currentUser.photo6,
                                    );
                                    print('プロフィールの変更');
                                    _currentUser =
                                        await widget._userFB.getCurrentUser(
                                      widget._currentUser.uid,
                                    );
                                    if (widget._fromEdit) {
                                      Navigator.of(context)
                                          .pop(_currentUser); //引数わたしてもどる
                                      Navigator.of(context)
                                          .pop(_currentUser); //引数わたしてもどる
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return MyProfPage(
                                              currentUser: _currentUser,
                                              userFB: widget._userFB,
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      Navigator.of(context).pop(_currentUser);
                                    }
                                  }
                                },
                                child: Container(
                                  width: size.width * 0.8,
                                  height: size.height * 0.045,
                                  decoration: BoxDecoration(
                                    color: pink,
                                    borderRadius: BorderRadius.circular(
                                      100,
                                    ),
                                    border: Border.all(
                                      color: pink,
                                      width: size.width * 0.0025,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "完了",
                                      style: TextStyle(
                                        fontSize: size.width * 0.05,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.width * 0.06,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
          //    ),
        ),
      ),
    );
  }

  Widget pickCrop1() {
    String imageUrl;
    if (web) {
      imageUrl = widget._currentUser.photo1;
      ui.platformViewRegistry.registerViewFactory(
        imageUrl,
        (int _) => html.ImageElement()..src = imageUrl,
      );
    }
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.width * 0.45,
      width: size.width * 0.31,
      child: (widget._currentUser.photo1 == null)
          ? GestureDetector(
              //photoが登録されていないなら
              onTap: () async {
                if (web) {
                  cropWeb1 = await pickAndCrop(
                    context: context,
                    mounted: mounted,
                    ratio: 2 / 3,
                  );
                  if (cropWeb1 != null) {
                    update = true;
                    setState(() {
                      if (photoWeb1 != null ||
                          widget._currentUser.photo1 != null) {
                        photoWeb1 = cropWeb1;
                        widget._currentUser.photo1 = null;
                      } else {
                        photoWeb1 = cropWeb1;
                      }
                    });
                  }

//                  pickWeb1 = await ImagePickerWeb.getImage(
//                      outputType: ImageType.bytes);
//                  if (pickWeb1 != null) {
//                    setState(() {
//                      update = true;
//                      readOnly = true;
//                    });
//                    //pickされたなら
//                    if (photoWeb1 != null ||
//                        widget._currentUser.photo1 != null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb1,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb1 = data;
//                              widget._currentUser.photo1 = null;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb1,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb1 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    }
//                    setState(() {});
//                  }
//                  readOnly = false;
                } else if (android || ios) {
                  FilePickerResult result =
                      await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result != null) {
                    pickMobile1 = File(result.files.single.path);
                    setState(() {
                      update = true;
                      readOnly = true;
                    });
                    //pickされたなら
                    if (photoMobile1 != null ||
                        widget._currentUser.photo1 != null) {
                      cropMobile1 = await cropImageMobile(
                        image: pickMobile1,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile1 != null) {
                        photoMobile1 = cropMobile1;
//                      oldStorageDelete1 = true;
                        widget._currentUser.photo1 = null;
                      }
                    } else {
                      cropMobile1 = await cropImageMobile(
                        image: pickMobile1,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile1 != null) {
                        photoMobile1 = cropMobile1;
                      }
                    }
                    setState(() {});
                  }
                  readOnly = false;
                }
              },
              child: (photoWeb1 != null || photoMobile1 != null) //pickされたなら
                  ? Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: (web)
                              ? Image.memory(photoWeb1)
                              : Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(photoMobile1),
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                //photo1があるならそのままuploadする
                                //changedがinitとおなじ場合何もしなくていい
                                //それ以外changedのurlをdownload->photo1としてupload

                                // old2はdeleteしなきゃいけない
                                // photo2かnewStorageあるならdeleteしなくても上書きされるから大丈夫
                                //それ以外の場合ー＞元の写真のままだからdeleteしなくていい
                                // ー＞どれもdeleteしなくていい。oldtrueもいらない

                                if (web) {
                                  if (photoWeb2 == null) {
                                    widget._currentUser.photo1 =
                                        widget._currentUser.photo2;
                                    photoWeb1 = null;
                                  } else {
                                    photoWeb1 = photoWeb2;
                                    widget._currentUser.photo1 = null;
//                                  oldStorageDelete1 = true;
                                  }
                                  if (photoWeb3 == null) {
                                    widget._currentUser.photo2 =
                                        widget._currentUser.photo3;
                                    photoWeb2 = null;
                                  } else {
                                    photoWeb2 = photoWeb3;
                                    widget._currentUser.photo2 = null;
                                  }
                                  if (photoWeb4 == null) {
                                    widget._currentUser.photo3 =
                                        widget._currentUser.photo4;
                                    photoWeb3 = null;
                                  } else {
                                    photoWeb3 = photoWeb4;
                                    widget._currentUser.photo3 = null;
                                  }
                                  if (photoWeb5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoWeb4 = null;
                                  } else {
                                    photoWeb4 = photoWeb5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoWeb6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoWeb5 = null;
                                  } else {
                                    photoWeb5 = photoWeb6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoWeb6 = null;
                                  widget._currentUser.photo6 = null;
                                  cropWeb1 = null;
                                  update = true;
                                } else if (android || ios) {
                                  if (photoMobile2 == null) {
                                    widget._currentUser.photo1 =
                                        widget._currentUser.photo2;
                                    photoMobile1 = null;
                                  } else {
                                    photoMobile1 = photoMobile2;
                                    widget._currentUser.photo1 = null;
//                                  oldStorageDelete1 = true;
                                  }
                                  if (photoMobile3 == null) {
                                    widget._currentUser.photo2 =
                                        widget._currentUser.photo3;
                                    photoMobile2 = null;
                                  } else {
                                    photoMobile2 = photoMobile3;
                                    widget._currentUser.photo2 = null;
                                  }
                                  if (photoMobile4 == null) {
                                    widget._currentUser.photo3 =
                                        widget._currentUser.photo4;
                                    photoMobile3 = null;
                                  } else {
                                    photoMobile3 = photoMobile4;
                                    widget._currentUser.photo3 = null;
                                  }
                                  if (photoMobile5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoMobile4 = null;
                                  } else {
                                    photoMobile4 = photoMobile5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoMobile6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoMobile5 = null;
                                  } else {
                                    photoMobile5 = photoMobile6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoMobile6 = null;
                                  widget._currentUser.photo6 = null;
                                  pickMobile1 = null;
                                  update = true;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: <Widget>[
                        Container(
                          color: veryLightGrey,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.add,
                            color: pink,
                            size: size.width * 0.07,
                          ),
                        ),
                      ],
                    ),
            )
          : GestureDetector(
//photoが登録されているなら
              onTap: () async {
                if (web) {
                  cropWeb1 = await pickAndCrop(
                    context: context,
                    mounted: mounted,
                    ratio: 2 / 3,
                  );
                  if (cropWeb1 != null) {
                    update = true;
                    setState(() {
                      if (photoWeb1 != null ||
                          widget._currentUser.photo1 != null) {
                        photoWeb1 = cropWeb1;
                        widget._currentUser.photo1 = null;
                      } else {
                        photoWeb1 = cropWeb1;
                      }
                    });
                  }
                } else if (android || ios) {
                  FilePickerResult result =
                      await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result != null) {
                    pickMobile1 = File(result.files.single.path);
                    setState(() {
                      update = true;
                      readOnly = true;
                    });
                    //pickされたなら
                    if (photoMobile1 != null ||
                        widget._currentUser.photo1 != null) {
                      cropMobile1 = await cropImageMobile(
                        image: pickMobile1,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile1 != null) {
                        photoMobile1 = cropMobile1;
//                      oldStorageDelete1 = true;
                        widget._currentUser.photo1 = null;
                      }
                    } else {
                      cropMobile1 = await cropImageMobile(
                        image: pickMobile1,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile1 != null) {
                        photoMobile1 = cropMobile1;
                      }
                    }
                    setState(() {});
                  }
                  readOnly = false;
                }
              },
              child: (photoWeb1 != null || photoMobile1 != null) //pickされたなら
                  ? //pickされたなら
                  Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: (web)
                              ? Image.memory(photoWeb1)
                              : Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(photoMobile1),
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                if (photoMobile2 == null) {
                                  widget._currentUser.photo1 =
                                      widget._currentUser.photo2;
                                  photoMobile1 = null;
                                } else {
                                  photoMobile1 = photoMobile2;
                                  widget._currentUser.photo1 = null;
//                                  oldStorageDelete1 = true;
                                }
                                if (photoMobile3 == null) {
                                  widget._currentUser.photo2 =
                                      widget._currentUser.photo3;
                                  photoMobile2 = null;
                                } else {
                                  photoMobile2 = photoMobile3;
                                  widget._currentUser.photo2 = null;
                                }
                                if (photoMobile4 == null) {
                                  widget._currentUser.photo3 =
                                      widget._currentUser.photo4;
                                  photoMobile3 = null;
                                } else {
                                  photoMobile3 = photoMobile4;
                                  widget._currentUser.photo3 = null;
                                }
                                if (photoMobile5 == null) {
                                  widget._currentUser.photo4 =
                                      widget._currentUser.photo5;
                                  photoMobile4 = null;
                                } else {
                                  photoMobile4 = photoMobile5;
                                  widget._currentUser.photo4 = null;
                                }
                                if (photoMobile6 == null) {
                                  widget._currentUser.photo5 =
                                      widget._currentUser.photo6;
                                  photoMobile5 = null;
                                } else {
                                  photoMobile5 = photoMobile6;
                                  widget._currentUser.photo5 = null;
                                }
                                photoMobile6 = null;
                                widget._currentUser.photo6 = null;
                                if (web) {
                                  cropWeb1 = null;
                                } else if (android || ios) {
                                  pickMobile1 = null;
                                }
                                update = true;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : //pickされてないなら
                  Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: (web)
                              ? HtmlElementView(
                                  viewType: imageUrl,
                                )
                              : ShowImageFromURL(
                                  photoURL: widget._currentUser.photo1,
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                if (web) {
                                  if (photoWeb2 == null) {
                                    widget._currentUser.photo1 =
                                        widget._currentUser.photo2;
                                    photoWeb1 = null;
                                  } else {
                                    photoWeb1 = photoWeb2;
                                    widget._currentUser.photo1 = null;
//                                  oldStorageDelete1 = true;
                                  }
                                  if (photoWeb3 == null) {
                                    widget._currentUser.photo2 =
                                        widget._currentUser.photo3;
                                    photoWeb2 = null;
                                  } else {
                                    photoWeb2 = photoWeb3;
                                    widget._currentUser.photo2 = null;
                                  }
                                  if (photoWeb4 == null) {
                                    widget._currentUser.photo3 =
                                        widget._currentUser.photo4;
                                    photoWeb3 = null;
                                  } else {
                                    photoWeb3 = photoWeb4;
                                    widget._currentUser.photo3 = null;
                                  }
                                  if (photoWeb5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoWeb4 = null;
                                  } else {
                                    photoWeb4 = photoWeb5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoWeb6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoWeb5 = null;
                                  } else {
                                    photoWeb5 = photoWeb6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoWeb6 = null;
                                  widget._currentUser.photo6 = null;
                                  if (web) {
                                    cropWeb1 = null;
                                  } else if (android || ios) {
                                    pickMobile1 = null;
                                  }
                                  update = true;
                                } else if (android || ios) {
                                  if (photoMobile2 == null) {
                                    widget._currentUser.photo1 =
                                        widget._currentUser.photo2;
                                    photoMobile1 = null;
                                  } else {
                                    photoMobile1 = photoMobile2;
                                    widget._currentUser.photo1 = null;
//                                  oldStorageDelete1 = true;
                                  }
                                  if (photoMobile3 == null) {
                                    widget._currentUser.photo2 =
                                        widget._currentUser.photo3;
                                    photoMobile2 = null;
                                  } else {
                                    photoMobile2 = photoMobile3;
                                    widget._currentUser.photo2 = null;
                                  }
                                  if (photoMobile4 == null) {
                                    widget._currentUser.photo3 =
                                        widget._currentUser.photo4;
                                    photoMobile3 = null;
                                  } else {
                                    photoMobile3 = photoMobile4;
                                    widget._currentUser.photo3 = null;
                                  }
                                  if (photoMobile5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoMobile4 = null;
                                  } else {
                                    photoMobile4 = photoMobile5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoMobile6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoMobile5 = null;
                                  } else {
                                    photoMobile5 = photoMobile6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoMobile6 = null;
                                  widget._currentUser.photo6 = null;
                                  if (web) {
                                    cropWeb1 = null;
                                  } else if (android || ios) {
                                    pickMobile1 = null;
                                  }
                                  update = true;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

  Widget pickCrop2() {
    Size size = MediaQuery.of(context).size;
    String imageUrl;
    if (web) {
      imageUrl = widget._currentUser.photo2;
      ui.platformViewRegistry.registerViewFactory(
        imageUrl,
        (int _) => html.ImageElement()..src = imageUrl,
      );
    }
    return Container(
      height: size.width * 0.45,
      width: size.width * 0.31,
      child: (widget._currentUser.photo2 == null)
          ? GestureDetector(
              //photoが登録されていないなら
              onTap: () async {
                if (web) {
                  cropWeb2 = await pickAndCrop(
                    context: context,
                    mounted: mounted,
                    ratio: 2 / 3,
                  );
                  if (cropWeb2 != null) {
                    update = true;
                    setState(() {
                      if (photoWeb2 != null ||
                          widget._currentUser.photo2 != null) {
                        photoWeb2 = cropWeb2;
                        widget._currentUser.photo2 = null;
                      } else if (photoWeb1 == null &&
                          widget._currentUser.photo1 == null) {
                        photoWeb1 = cropWeb2;
                      } else {
                        photoWeb2 = cropWeb2;
                      }
                    });
                  }
//                  pickWeb2 = await ImagePickerWeb.getImage(
//                      outputType: ImageType.bytes);
//                  if (pickWeb2 != null) {
//                    setState(() {
//                      update = true;
//                      readOnly = true;
//                    });
//                    //pickされたなら
//                    if (photoWeb2 != null ||
//                        widget._currentUser.photo2 != null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb2,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb2 = data;
//                              widget._currentUser.photo2 = null;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else if (photoWeb1 == null &&
//                        widget._currentUser.photo1 == null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb2,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb1 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb2,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb2 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    }
//                    setState(() {
//                      readOnly = false;
//                    });
//                  }
                } else if (android || ios) {
                  FilePickerResult result =
                      await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result != null) {
                    pickMobile2 = File(result.files.single.path);
                    setState(() {
                      update = true;
                      readOnly = true;
                    });
                    //pickされたなら
                    if (photoMobile2 != null ||
                        widget._currentUser.photo2 != null) {
                      cropMobile2 = await cropImageMobile(
                        image: pickMobile2,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile2 != null) {
                        photoMobile2 = cropMobile2;
                        widget._currentUser.photo2 = null;
                      }
                    } else if (photoMobile1 == null &&
                        widget._currentUser.photo1 == null) {
                      cropMobile2 = await cropImageMobile(
                        image: pickMobile2,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile2 != null) {
                        photoMobile1 = cropMobile2;
                      }
                    } else {
                      cropMobile2 = await cropImageMobile(
                        image: pickMobile2,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile2 != null) {
                        photoMobile2 = cropMobile2;
                      }
                    }
                    setState(() {
                      readOnly = false;
                    });
                  }
                }
              },
              child: (photoWeb2 != null || photoMobile2 != null) //pickされたなら
                  ? Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: (web)
                              ? Image.memory(photoWeb2)
                              : Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(photoMobile2),
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                if (web) {
                                  if (photoWeb3 == null) {
                                    widget._currentUser.photo2 =
                                        widget._currentUser.photo3;
                                    photoWeb2 = null;
                                  } else {
                                    photoWeb2 = photoWeb3;
                                    widget._currentUser.photo2 = null;
                                  }
                                  if (photoWeb4 == null) {
                                    widget._currentUser.photo3 =
                                        widget._currentUser.photo4;
                                    photoWeb3 = null;
                                  } else {
                                    photoWeb3 = photoWeb4;
                                    widget._currentUser.photo3 = null;
                                  }
                                  if (photoWeb5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoWeb4 = null;
                                  } else {
                                    photoWeb4 = photoWeb5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoWeb6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoWeb5 = null;
                                  } else {
                                    photoWeb5 = photoWeb6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoWeb6 = null;
                                  widget._currentUser.photo6 = null;
                                  cropWeb2 = null;
                                  update = true;
                                } else if (android || ios) {
                                  if (photoMobile3 == null) {
                                    widget._currentUser.photo2 =
                                        widget._currentUser.photo3;
                                    photoMobile2 = null;
                                  } else {
                                    photoMobile2 = photoMobile3;
                                    widget._currentUser.photo2 = null;
                                  }
                                  if (photoMobile4 == null) {
                                    widget._currentUser.photo3 =
                                        widget._currentUser.photo4;
                                    photoMobile3 = null;
                                  } else {
                                    photoMobile3 = photoMobile4;
                                    widget._currentUser.photo3 = null;
                                  }
                                  if (photoMobile5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoMobile4 = null;
                                  } else {
                                    photoMobile4 = photoMobile5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoMobile6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoMobile5 = null;
                                  } else {
                                    photoMobile5 = photoMobile6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoMobile6 = null;
                                  widget._currentUser.photo6 = null;
                                  pickMobile2 = null;
                                  update = true;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: <Widget>[
                        Container(
                          color: veryLightGrey,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.add,
                            color: pink,
                            size: size.width * 0.07,
                          ),
                        ),
                      ],
                    ),
            )
          : GestureDetector(
//photoが登録されているなら
              onTap: () async {
                if (web) {
                  cropWeb2 = await pickAndCrop(
                    context: context,
                    mounted: mounted,
                    ratio: 2 / 3,
                  );
                  if (cropWeb2 != null) {
                    update = true;
                    setState(() {
                      if (photoWeb2 != null ||
                          widget._currentUser.photo2 != null) {
                        photoWeb2 = cropWeb2;
                        widget._currentUser.photo2 = null;
                      } else if (photoWeb1 == null &&
                          widget._currentUser.photo1 == null) {
                        photoWeb1 = cropWeb2;
                      } else {
                        photoWeb2 = cropWeb2;
                      }
                    });
                  }
                } else if (android || ios) {
                  FilePickerResult result =
                      await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result != null) {
                    pickMobile2 = File(result.files.single.path);
                    setState(() {
                      update = true;
                      readOnly = true;
                    });
                    //pickされたなら
                    if (photoMobile2 != null ||
                        widget._currentUser.photo2 != null) {
                      cropMobile2 = await cropImageMobile(
                        image: pickMobile2,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile2 != null) {
                        photoMobile2 = cropMobile2;
                        widget._currentUser.photo2 = null;
                      }
                    } else if (photoMobile1 == null &&
                        widget._currentUser.photo1 == null) {
                      cropMobile2 = await cropImageMobile(
                        image: pickMobile2,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile2 != null) {
                        photoMobile1 = cropMobile2;
                      }
                    } else {
                      cropMobile2 = await cropImageMobile(
                        image: pickMobile2,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile2 != null) {
                        photoMobile2 = cropMobile2;
                      }
                    }
                    setState(() {
                      readOnly = false;
                    });
                  }
                }
              },
              child: (photoWeb2 != null || photoMobile2 != null) //pickされたなら
                  ? //pickされたなら
                  Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: (web)
                              ? Image.memory(photoWeb2)
                              : Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(photoMobile2),
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                if (web) {
                                  if (photoWeb3 == null) {
                                    widget._currentUser.photo2 =
                                        widget._currentUser.photo3;
                                    photoWeb2 = null;
                                  } else {
                                    photoWeb2 = photoWeb3;
                                    widget._currentUser.photo2 = null;
                                  }
                                  if (photoWeb4 == null) {
                                    widget._currentUser.photo3 =
                                        widget._currentUser.photo4;
                                    photoWeb3 = null;
                                  } else {
                                    photoWeb3 = photoWeb4;
                                    widget._currentUser.photo3 = null;
                                  }
                                  if (photoWeb5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoWeb4 = null;
                                  } else {
                                    photoWeb4 = photoWeb5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoWeb6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoWeb5 = null;
                                  } else {
                                    photoWeb5 = photoWeb6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoWeb6 = null;
                                  widget._currentUser.photo6 = null;
                                  cropWeb2 = null;
                                  update = true;
                                } else if (android || ios) {
                                  if (photoMobile3 == null) {
                                    widget._currentUser.photo2 =
                                        widget._currentUser.photo3;
                                    photoMobile2 = null;
                                  } else {
                                    photoMobile2 = photoMobile3;
                                    widget._currentUser.photo2 = null;
                                  }
                                  if (photoMobile4 == null) {
                                    widget._currentUser.photo3 =
                                        widget._currentUser.photo4;
                                    photoMobile3 = null;
                                  } else {
                                    photoMobile3 = photoMobile4;
                                    widget._currentUser.photo3 = null;
                                  }
                                  if (photoMobile5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoMobile4 = null;
                                  } else {
                                    photoMobile4 = photoMobile5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoMobile6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoMobile5 = null;
                                  } else {
                                    photoMobile5 = photoMobile6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoMobile6 = null;
                                  widget._currentUser.photo6 = null;
                                  pickMobile2 = null;
                                  update = true;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : //pickされてないなら
                  Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: (web)
                              ? HtmlElementView(
                                  viewType: imageUrl,
                                )
                              : ShowImageFromURL(
                                  photoURL: widget._currentUser.photo2,
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                if (web) {
                                  if (photoWeb3 == null) {
                                    widget._currentUser.photo2 =
                                        widget._currentUser.photo3;
                                    photoWeb2 = null;
                                  } else {
                                    photoWeb2 = photoWeb3;
                                    widget._currentUser.photo2 = null;
                                  }
                                  if (photoWeb4 == null) {
                                    widget._currentUser.photo3 =
                                        widget._currentUser.photo4;
                                    photoWeb3 = null;
                                  } else {
                                    photoWeb3 = photoWeb4;
                                    widget._currentUser.photo3 = null;
                                  }
                                  if (photoWeb5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoWeb4 = null;
                                  } else {
                                    photoWeb4 = photoWeb5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoWeb6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoWeb5 = null;
                                  } else {
                                    photoWeb5 = photoWeb6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoWeb6 = null;
                                  widget._currentUser.photo6 = null;
                                  cropWeb2 = null;
                                  update = true;
                                } else if (android || ios) {
                                  if (photoMobile3 == null) {
                                    widget._currentUser.photo2 =
                                        widget._currentUser.photo3;
                                    photoMobile2 = null;
                                  } else {
                                    photoMobile2 = photoMobile3;
                                    widget._currentUser.photo2 = null;
                                  }
                                  if (photoMobile4 == null) {
                                    widget._currentUser.photo3 =
                                        widget._currentUser.photo4;
                                    photoMobile3 = null;
                                  } else {
                                    photoMobile3 = photoMobile4;
                                    widget._currentUser.photo3 = null;
                                  }
                                  if (photoMobile5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoMobile4 = null;
                                  } else {
                                    photoMobile4 = photoMobile5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoMobile6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoMobile5 = null;
                                  } else {
                                    photoMobile5 = photoMobile6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoMobile6 = null;
                                  widget._currentUser.photo6 = null;
                                  pickMobile2 = null;
                                  update = true;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

  Widget pickCrop3() {
    Size size = MediaQuery.of(context).size;
    String imageUrl;
    if (web) {
      imageUrl = widget._currentUser.photo3;
      ui.platformViewRegistry.registerViewFactory(
        imageUrl,
        (int _) => html.ImageElement()..src = imageUrl,
      );
    }
    return Container(
      height: size.width * 0.45,
      width: size.width * 0.31,
      child: (widget._currentUser.photo3 == null)
          ? GestureDetector(
              //photoが登録されていないなら
              onTap: () async {
                if (web) {
                  cropWeb3 = await pickAndCrop(
                    context: context,
                    mounted: mounted,
                    ratio: 2 / 3,
                  );
                  if (cropWeb3 != null) {
                    update = true;
                    setState(() {
                      if (photoWeb3 != null ||
                          widget._currentUser.photo3 != null) {
                        photoWeb3 = cropWeb3;
                        widget._currentUser.photo3 = null;
                      } else if (photoWeb1 == null &&
                          widget._currentUser.photo1 == null) {
                        photoWeb1 = cropWeb3;
                      } else if (photoWeb2 == null &&
                          widget._currentUser.photo2 == null) {
                        photoWeb2 = cropWeb3;
                      } else {
                        photoWeb3 = cropWeb3;
                      }
                    });
                  }
//                  pickWeb3 = await ImagePickerWeb.getImage(
//                      outputType: ImageType.bytes);
//                  if (pickWeb3 != null) {
//                    setState(() {
//                      update = true;
//                      readOnly = true;
//                    });
//                    //pickされたなら
//                    if (photoWeb3 != null ||
//                        widget._currentUser.photo3 != null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb3,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb3 = data;
//                              widget._currentUser.photo3 = null;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else if (photoWeb1 == null &&
//                        widget._currentUser.photo1 == null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb3,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb1 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else if (photoWeb2 == null &&
//                        widget._currentUser.photo2 == null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb3,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb2 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb3,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb3 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    }
//                    setState(() {
//                      readOnly = false;
//                    });
//                  }
                } else if (android || ios) {
                  FilePickerResult result =
                      await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result != null) {
                    pickMobile3 = File(result.files.single.path);
                    setState(() {
                      update = true;
                      readOnly = true;
                    });
                    //pickされたなら
                    if (photoMobile3 != null ||
                        widget._currentUser.photo3 != null) {
                      cropMobile3 = await cropImageMobile(
                        image: pickMobile3,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile3 != null) {
                        photoMobile3 = cropMobile3;
                        widget._currentUser.photo3 = null;
                      }
                    } else if (photoMobile1 == null &&
                        widget._currentUser.photo1 == null) {
                      cropMobile3 = await cropImageMobile(
                        image: pickMobile3,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile3 != null) {
                        photoMobile1 = cropMobile3;
                      }
                    } else if (photoMobile2 == null &&
                        widget._currentUser.photo2 == null) {
                      cropMobile3 = await cropImageMobile(
                        image: pickMobile3,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile3 != null) {
                        photoMobile2 = cropMobile3;
                      }
                    } else {
                      cropMobile3 = await cropImageMobile(
                        image: pickMobile3,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile3 != null) {
                        photoMobile3 = cropMobile3;
                      }
                    }
                    setState(() {
                      readOnly = false;
                    });
                  }
                }
              },
              child: (photoWeb3 != null || photoMobile3 != null) //pickされたなら
                  ? Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: (web)
                              ? Image.memory(photoWeb3)
                              : Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(photoMobile3),
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                if (web) {
                                  if (photoWeb4 == null) {
                                    widget._currentUser.photo3 =
                                        widget._currentUser.photo4;
                                    photoWeb3 = null;
                                  } else {
                                    photoWeb3 = photoWeb4;
                                    widget._currentUser.photo3 = null;
                                  }
                                  if (photoWeb5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoWeb4 = null;
                                  } else {
                                    photoWeb4 = photoWeb5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoWeb6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoWeb5 = null;
                                  } else {
                                    photoWeb5 = photoWeb6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoWeb6 = null;
                                  widget._currentUser.photo6 = null;
                                  cropWeb3 = null;
                                  update = true;
                                } else if (android || ios) {
                                  if (photoMobile4 == null) {
                                    widget._currentUser.photo3 =
                                        widget._currentUser.photo4;
                                    photoMobile3 = null;
                                  } else {
                                    photoMobile3 = photoMobile4;
                                    widget._currentUser.photo3 = null;
                                  }
                                  if (photoMobile5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoMobile4 = null;
                                  } else {
                                    photoMobile4 = photoMobile5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoMobile6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoMobile5 = null;
                                  } else {
                                    photoMobile5 = photoMobile6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoMobile6 = null;
                                  widget._currentUser.photo6 = null;
                                  pickMobile3 = null;
                                  update = true;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: <Widget>[
                        Container(
                          color: veryLightGrey,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.add,
                            color: pink,
                            size: size.width * 0.07,
                          ),
                        ),
                      ],
                    ),
            )
          : GestureDetector(
//photoが登録されているなら
              onTap: () async {
                if (web) {
                  if (web) {
                    cropWeb3 = await pickAndCrop(
                      context: context,
                      mounted: mounted,
                      ratio: 2 / 3,
                    );
                    if (cropWeb3 != null) {
                      update = true;
                      setState(() {
                        if (photoWeb3 != null ||
                            widget._currentUser.photo3 != null) {
                          photoWeb3 = cropWeb3;
                          widget._currentUser.photo3 = null;
                        } else if (photoWeb1 == null &&
                            widget._currentUser.photo1 == null) {
                          photoWeb1 = cropWeb3;
                        } else if (photoWeb2 == null &&
                            widget._currentUser.photo2 == null) {
                          photoWeb2 = cropWeb3;
                        } else {
                          photoWeb3 = cropWeb3;
                        }
                      });
                    }
                  } else if (android || ios) {
                    FilePickerResult result = await FilePicker.platform
                        .pickFiles(type: FileType.image);
                    if (result != null) {
                      pickMobile3 = File(result.files.single.path);
                      setState(() {
                        update = true;
                        readOnly = true;
                      });
                      //pickされたなら
                      if (photoMobile3 != null ||
                          widget._currentUser.photo3 != null) {
                        cropMobile3 = await cropImageMobile(
                          image: pickMobile3,
                          width: 1.0,
                          height: 1.5,
                        );
                        if (cropMobile3 != null) {
                          photoMobile3 = cropMobile3;
                          widget._currentUser.photo3 = null;
                        }
                      } else if (photoMobile1 == null &&
                          widget._currentUser.photo1 == null) {
                        cropMobile3 = await cropImageMobile(
                          image: pickMobile3,
                          width: 1.0,
                          height: 1.5,
                        );
                        if (cropMobile3 != null) {
                          photoMobile1 = cropMobile3;
                        }
                      } else if (photoMobile2 == null &&
                          widget._currentUser.photo2 == null) {
                        cropMobile3 = await cropImageMobile(
                          image: pickMobile3,
                          width: 1.0,
                          height: 1.5,
                        );
                        if (cropMobile3 != null) {
                          photoMobile2 = cropMobile3;
                        }
                      } else {
                        cropMobile3 = await cropImageMobile(
                          image: pickMobile3,
                          width: 1.0,
                          height: 1.5,
                        );
                        if (cropMobile3 != null) {
                          photoMobile3 = cropMobile3;
                        }
                      }
                      setState(() {
                        readOnly = false;
                      });
                    }
                  }
                }
              },
              child: (photoWeb3 != null || photoMobile3 != null) //pickされたなら
                  ? //pickされたなら
                  Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: (web)
                              ? Image.memory(photoWeb3)
                              : Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(photoMobile3),
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                if (web) {
                                  if (photoWeb4 == null) {
                                    widget._currentUser.photo3 =
                                        widget._currentUser.photo4;
                                    photoWeb3 = null;
                                  } else {
                                    photoWeb3 = photoWeb4;
                                    widget._currentUser.photo3 = null;
                                  }
                                  if (photoWeb5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoWeb4 = null;
                                  } else {
                                    photoWeb4 = photoWeb5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoWeb6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoWeb5 = null;
                                  } else {
                                    photoWeb5 = photoWeb6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoWeb6 = null;
                                  widget._currentUser.photo6 = null;
                                  cropWeb3 = null;
                                  update = true;
                                } else if (android || ios) {
                                  if (photoMobile4 == null) {
                                    widget._currentUser.photo3 =
                                        widget._currentUser.photo4;
                                    photoMobile3 = null;
                                  } else {
                                    photoMobile3 = photoMobile4;
                                    widget._currentUser.photo3 = null;
                                  }
                                  if (photoMobile5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoMobile4 = null;
                                  } else {
                                    photoMobile4 = photoMobile5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoMobile6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoMobile5 = null;
                                  } else {
                                    photoMobile5 = photoMobile6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoMobile6 = null;
                                  widget._currentUser.photo6 = null;
                                  pickMobile3 = null;
                                  update = true;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : //pickされてないなら
                  Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: (web)
                              ? HtmlElementView(
                                  viewType: imageUrl,
                                )
                              : ShowImageFromURL(
                                  photoURL: widget._currentUser.photo3,
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                if (web) {
                                  if (photoWeb4 == null) {
                                    widget._currentUser.photo3 =
                                        widget._currentUser.photo4;
                                    photoWeb3 = null;
                                  } else {
                                    photoWeb3 = photoWeb4;
                                    widget._currentUser.photo3 = null;
                                  }
                                  if (photoWeb5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoWeb4 = null;
                                  } else {
                                    photoWeb4 = photoWeb5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoWeb6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoWeb5 = null;
                                  } else {
                                    photoWeb5 = photoWeb6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoWeb6 = null;
                                  widget._currentUser.photo6 = null;
                                  cropWeb3 = null;
                                  update = true;
                                } else if (android || ios) {
                                  if (photoMobile4 == null) {
                                    widget._currentUser.photo3 =
                                        widget._currentUser.photo4;
                                    photoMobile3 = null;
                                  } else {
                                    photoMobile3 = photoMobile4;
                                    widget._currentUser.photo3 = null;
                                  }
                                  if (photoMobile5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoMobile4 = null;
                                  } else {
                                    photoMobile4 = photoMobile5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoMobile6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoMobile5 = null;
                                  } else {
                                    photoMobile5 = photoMobile6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoMobile6 = null;
                                  widget._currentUser.photo6 = null;
                                  pickMobile3 = null;
                                  update = true;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

  Widget pickCrop4() {
    Size size = MediaQuery.of(context).size;
    String imageUrl;
    if (web) {
      imageUrl = widget._currentUser.photo4;
      ui.platformViewRegistry.registerViewFactory(
        imageUrl,
        (int _) => html.ImageElement()..src = imageUrl,
      );
    }
    return Container(
      height: size.width * 0.45,
      width: size.width * 0.31,
      child: (widget._currentUser.photo4 == null)
          ? GestureDetector(
              //photoが登録されていないなら
              onTap: () async {
                if (web) {
                  cropWeb4 = await pickAndCrop(
                    context: context,
                    mounted: mounted,
                    ratio: 2 / 3,
                  );
                  if (cropWeb4 != null) {
                    update = true;
                    setState(() {
                      if (photoWeb4 != null ||
                          widget._currentUser.photo4 != null) {
                        photoWeb4 = cropWeb4;
                        widget._currentUser.photo4 = null;
                      } else if (photoWeb1 == null &&
                          widget._currentUser.photo1 == null) {
                        photoWeb1 = cropWeb4;
                      } else if (photoWeb2 == null &&
                          widget._currentUser.photo2 == null) {
                        photoWeb2 = cropWeb4;
                      } else if (photoWeb3 == null &&
                          widget._currentUser.photo3 == null) {
                        photoWeb3 = cropWeb4;
                      } else {
                        photoWeb4 = cropWeb4;
                      }
                    });
                  }

//                  pickWeb4 = await ImagePickerWeb.getImage(
//                      outputType: ImageType.bytes);
//                  if (pickWeb4 != null) {
//                    setState(() {
//                      update = true;
//                      readOnly = true;
//                    });
//                    //pickされたなら
//                    if (photoWeb4 != null ||
//                        widget._currentUser.photo4 != null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb4,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb4 = data;
//                              widget._currentUser.photo4 = null;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else if (photoWeb1 == null &&
//                        widget._currentUser.photo1 == null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb4,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb1 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else if (photoWeb2 == null &&
//                        widget._currentUser.photo2 == null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb4,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb2 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else if (photoWeb3 == null &&
//                        widget._currentUser.photo3 == null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb4,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb3 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb4,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb4 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    }
//                    setState(() {
//                      readOnly = false;
//                    });
//                  }
                } else if (android || ios) {
                  FilePickerResult result =
                      await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result != null) {
                    pickMobile4 = File(result.files.single.path);
                    setState(() {
                      update = true;
                      readOnly = true;
                    });
                    //pickされたなら
                    if (photoMobile4 != null ||
                        widget._currentUser.photo4 != null) {
                      cropMobile4 = await cropImageMobile(
                        image: pickMobile4,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile4 != null) {
                        photoMobile4 = cropMobile4;
                        widget._currentUser.photo4 = null;
                      }
                    } else if (photoMobile1 == null &&
                        widget._currentUser.photo1 == null) {
                      cropMobile4 = await cropImageMobile(
                        image: pickMobile4,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile4 != null) {
                        photoMobile1 = cropMobile4;
                      }
                    } else if (photoMobile2 == null &&
                        widget._currentUser.photo2 == null) {
                      cropMobile4 = await cropImageMobile(
                        image: pickMobile4,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile4 != null) {
                        photoMobile2 = cropMobile4;
                      }
                    } else if (photoMobile3 == null &&
                        widget._currentUser.photo3 == null) {
                      cropMobile4 = await cropImageMobile(
                        image: pickMobile4,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile4 != null) {
                        photoMobile3 = cropMobile4;
                      }
                    } else {
                      cropMobile4 = await cropImageMobile(
                        image: pickMobile4,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile4 != null) {
                        photoMobile4 = cropMobile4;
                      }
                    }
                    setState(() {
                      readOnly = false;
                    });
                  }
                }
              },
              child: (photoWeb4 != null || photoMobile4 != null) //pickされたなら
                  ? Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: (web)
                              ? Image.memory(photoWeb4)
                              : Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(photoMobile4),
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                if (web) {
                                  if (photoWeb5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoWeb4 = null;
                                  } else {
                                    photoWeb4 = photoWeb5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoWeb6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoWeb5 = null;
                                  } else {
                                    photoWeb5 = photoWeb6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoWeb6 = null;
                                  widget._currentUser.photo6 = null;
                                  cropWeb4 = null;
                                  update = true;
                                } else if (android || ios) {
                                  if (photoMobile5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoMobile4 = null;
                                  } else {
                                    photoMobile4 = photoMobile5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoMobile6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoMobile5 = null;
                                  } else {
                                    photoMobile5 = photoMobile6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoMobile6 = null;
                                  widget._currentUser.photo6 = null;
                                  pickMobile4 = null;
                                  update = true;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: <Widget>[
                        Container(
                          color: veryLightGrey,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.add,
                            color: pink,
                            size: size.width * 0.07,
                          ),
                        ),
                      ],
                    ),
            )
          : GestureDetector(
//photoが登録されているなら
              onTap: () async {
                if (web) {
                  cropWeb4 = await pickAndCrop(
                    context: context,
                    mounted: mounted,
                    ratio: 2 / 3,
                  );
                  if (cropWeb4 != null) {
                    update = true;
                    setState(() {
                      if (photoWeb4 != null ||
                          widget._currentUser.photo4 != null) {
                        photoWeb4 = cropWeb4;
                        widget._currentUser.photo4 = null;
                      } else if (photoWeb1 == null &&
                          widget._currentUser.photo1 == null) {
                        photoWeb1 = cropWeb4;
                      } else if (photoWeb2 == null &&
                          widget._currentUser.photo2 == null) {
                        photoWeb2 = cropWeb4;
                      } else if (photoWeb3 == null &&
                          widget._currentUser.photo3 == null) {
                        photoWeb3 = cropWeb4;
                      } else {
                        photoWeb4 = cropWeb4;
                      }
                    });
                  }
                } else if (android || ios) {
                  FilePickerResult result =
                      await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result != null) {
                    pickMobile4 = File(result.files.single.path);
                    setState(() {
                      update = true;
                      readOnly = true;
                    });
                    //pickされたなら
                    if (photoMobile4 != null ||
                        widget._currentUser.photo4 != null) {
                      cropMobile4 = await cropImageMobile(
                        image: pickMobile4,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile4 != null) {
                        photoMobile4 = cropMobile4;
                        widget._currentUser.photo4 = null;
                      }
                    } else if (photoMobile1 == null &&
                        widget._currentUser.photo1 == null) {
                      cropMobile4 = await cropImageMobile(
                        image: pickMobile4,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile4 != null) {
                        photoMobile1 = cropMobile4;
                      }
                    } else if (photoMobile2 == null &&
                        widget._currentUser.photo2 == null) {
                      cropMobile4 = await cropImageMobile(
                        image: pickMobile4,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile4 != null) {
                        photoMobile2 = cropMobile4;
                      }
                    } else if (photoMobile3 == null &&
                        widget._currentUser.photo3 == null) {
                      cropMobile4 = await cropImageMobile(
                        image: pickMobile4,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile4 != null) {
                        photoMobile3 = cropMobile4;
                      }
                    } else {
                      cropMobile4 = await cropImageMobile(
                        image: pickMobile4,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile4 != null) {
                        photoMobile4 = cropMobile4;
                      }
                    }
                    setState(() {
                      readOnly = false;
                    });
                  }
                }
              },
              child: (photoWeb4 != null || photoMobile4 != null) //pickされたなら
                  ? //pickされたなら
                  Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: (web)
                              ? Image.memory(photoWeb5)
                              : Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(photoMobile5),
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                if (web) {
                                  if (photoWeb5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoWeb4 = null;
                                  } else {
                                    photoWeb4 = photoWeb5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoWeb6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoWeb5 = null;
                                  } else {
                                    photoWeb5 = photoWeb6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoWeb6 = null;
                                  widget._currentUser.photo6 = null;
                                  cropWeb4 = null;
                                  update = true;
                                } else if (android || ios) {
                                  if (photoMobile5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoMobile4 = null;
                                  } else {
                                    photoMobile4 = photoMobile5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoMobile6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoMobile5 = null;
                                  } else {
                                    photoMobile5 = photoMobile6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoMobile6 = null;
                                  widget._currentUser.photo6 = null;
                                  pickMobile4 = null;
                                  update = true;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : //pickされてないなら
                  Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: (web)
                              ? HtmlElementView(
                                  viewType: imageUrl,
                                )
                              : ShowImageFromURL(
                                  photoURL: widget._currentUser.photo4,
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                if (web) {
                                  if (photoWeb5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoWeb4 = null;
                                  } else {
                                    photoWeb4 = photoWeb5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoWeb6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoWeb5 = null;
                                  } else {
                                    photoWeb5 = photoWeb6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoWeb6 = null;
                                  widget._currentUser.photo6 = null;
                                  cropWeb4 = null;
                                  update = true;
                                } else if (android || ios) {
                                  if (photoMobile5 == null) {
                                    widget._currentUser.photo4 =
                                        widget._currentUser.photo5;
                                    photoMobile4 = null;
                                  } else {
                                    photoMobile4 = photoMobile5;
                                    widget._currentUser.photo4 = null;
                                  }
                                  if (photoMobile6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoMobile5 = null;
                                  } else {
                                    photoMobile5 = photoMobile6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoMobile6 = null;
                                  widget._currentUser.photo6 = null;
                                  pickMobile4 = null;
                                  update = true;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

  Widget pickCrop5() {
    Size size = MediaQuery.of(context).size;
    String imageUrl;
    if (web) {
      imageUrl = widget._currentUser.photo5;
      ui.platformViewRegistry.registerViewFactory(
        imageUrl,
        (int _) => html.ImageElement()..src = imageUrl,
      );
    }
    return Container(
      height: size.width * 0.45,
      width: size.width * 0.31,
      child: (widget._currentUser.photo5 == null)
          ? GestureDetector(
              //photoが登録されていないなら
              onTap: () async {
                if (web) {
                  cropWeb5 = await pickAndCrop(
                    context: context,
                    mounted: mounted,
                    ratio: 2 / 3,
                  );
                  if (cropWeb5 != null) {
                    update = true;
                    setState(() {
                      if (photoWeb5 != null ||
                          widget._currentUser.photo5 != null) {
                        photoWeb5 = cropWeb5;
                        widget._currentUser.photo5 = null;
                      } else if (photoWeb1 == null &&
                          widget._currentUser.photo1 == null) {
                        photoWeb1 = cropWeb5;
                      } else if (photoWeb2 == null &&
                          widget._currentUser.photo2 == null) {
                        photoWeb2 = cropWeb5;
                      } else if (photoWeb3 == null &&
                          widget._currentUser.photo3 == null) {
                        photoWeb3 = cropWeb5;
                      } else if (photoWeb4 == null &&
                          widget._currentUser.photo4 == null) {
                        photoWeb4 = cropWeb5;
                      } else {
                        photoWeb5 = cropWeb5;
                      }
                    });
                  }
//                  pickWeb5 = await ImagePickerWeb.getImage(
//                      outputType: ImageType.bytes);
//                  if (pickWeb5 != null) {
//                    setState(() {
//                      update = true;
//                      readOnly = true;
//                    });
//                    //pickされたなら
//                    if (photoWeb5 != null ||
//                        widget._currentUser.photo5 != null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb5,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb5 = data;
//                              widget._currentUser.photo5 = null;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else if (photoWeb1 == null &&
//                        widget._currentUser.photo1 == null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb5,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb1 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else if (photoWeb2 == null &&
//                        widget._currentUser.photo2 == null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb5,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb2 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else if (photoWeb3 == null &&
//                        widget._currentUser.photo3 == null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb5,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb3 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else if (photoWeb4 == null &&
//                        widget._currentUser.photo4 == null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb5,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb4 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb5,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb5 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    }
//                    setState(() {
//                      readOnly = false;
//                    });
//                  }
                } else if (android || ios) {
                  FilePickerResult result =
                      await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result != null) {
                    pickMobile5 = File(result.files.single.path);
                    setState(() {
                      update = true;
                      readOnly = true;
                    });
                    //pickされたなら
                    if (photoMobile5 != null ||
                        widget._currentUser.photo5 != null) {
                      cropMobile5 = await cropImageMobile(
                        image: pickMobile5,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile5 != null) {
                        photoMobile5 = cropMobile5;
                        widget._currentUser.photo5 = null;
                      }
                    } else if (photoMobile1 == null &&
                        widget._currentUser.photo1 == null) {
                      cropMobile5 = await cropImageMobile(
                        image: pickMobile5,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile5 != null) {
                        photoMobile1 = cropMobile5;
                      }
                    } else if (photoMobile2 == null &&
                        widget._currentUser.photo2 == null) {
                      cropMobile5 = await cropImageMobile(
                        image: pickMobile5,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile5 != null) {
                        photoMobile2 = cropMobile5;
                      }
                    } else if (photoMobile3 == null &&
                        widget._currentUser.photo3 == null) {
                      cropMobile5 = await cropImageMobile(
                        image: pickMobile5,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile5 != null) {
                        photoMobile3 = cropMobile5;
                      }
                    } else if (photoMobile4 == null &&
                        widget._currentUser.photo4 == null) {
                      cropMobile5 = await cropImageMobile(
                        image: pickMobile5,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile5 != null) {
                        photoMobile4 = cropMobile5;
                      }
                    } else {
                      cropMobile5 = await cropImageMobile(
                        image: pickMobile5,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile5 != null) {
                        photoMobile5 = cropMobile5;
                      }
                    }
                    setState(() {
                      readOnly = false;
                    });
                  }
                }
              },
              child: (photoWeb5 != null || photoMobile5 != null) //pickされたなら
                  ? Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: (web)
                              ? Image.memory(photoWeb5)
                              : Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(photoMobile5),
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                if (web) {
                                  if (photoWeb6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoWeb5 = null;
                                  } else {
                                    photoWeb5 = photoWeb6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoWeb6 = null;
                                  widget._currentUser.photo6 = null;
                                  cropWeb5 = null;
                                  update = true;
                                } else if (android || ios) {
                                  if (photoMobile6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoMobile5 = null;
                                  } else {
                                    photoMobile5 = photoMobile6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoMobile6 = null;
                                  widget._currentUser.photo6 = null;
                                  pickMobile5 = null;
                                  update = true;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: <Widget>[
                        Container(
                          color: veryLightGrey,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.add,
                            color: pink,
                            size: size.width * 0.07,
                          ),
                        ),
                      ],
                    ),
            )
          : GestureDetector(
//photoが登録されているなら
              onTap: () async {
                if (web) {
                  cropWeb5 = await pickAndCrop(
                    context: context,
                    mounted: mounted,
                    ratio: 2 / 3,
                  );
                  if (cropWeb5 != null) {
                    update = true;
                    setState(() {
                      if (photoWeb5 != null ||
                          widget._currentUser.photo5 != null) {
                        photoWeb5 = cropWeb5;
                        widget._currentUser.photo5 = null;
                      } else if (photoWeb1 == null &&
                          widget._currentUser.photo1 == null) {
                        photoWeb1 = cropWeb5;
                      } else if (photoWeb2 == null &&
                          widget._currentUser.photo2 == null) {
                        photoWeb2 = cropWeb5;
                      } else if (photoWeb3 == null &&
                          widget._currentUser.photo3 == null) {
                        photoWeb3 = cropWeb5;
                      } else if (photoWeb4 == null &&
                          widget._currentUser.photo4 == null) {
                        photoWeb4 = cropWeb5;
                      } else {
                        photoWeb5 = cropWeb5;
                      }
                    });
                  }
                } else if (android || ios) {
                  FilePickerResult result =
                      await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result != null) {
                    pickMobile5 = File(result.files.single.path);
                    setState(() {
                      update = true;
                      readOnly = true;
                    });
                    //pickされたなら
                    if (photoMobile5 != null ||
                        widget._currentUser.photo5 != null) {
                      cropMobile5 = await cropImageMobile(
                        image: pickMobile5,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile5 != null) {
                        photoMobile5 = cropMobile5;
                        widget._currentUser.photo5 = null;
                      }
                    } else if (photoMobile1 == null &&
                        widget._currentUser.photo1 == null) {
                      cropMobile5 = await cropImageMobile(
                        image: pickMobile5,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile5 != null) {
                        photoMobile1 = cropMobile5;
                      }
                    } else if (photoMobile2 == null &&
                        widget._currentUser.photo2 == null) {
                      cropMobile5 = await cropImageMobile(
                        image: pickMobile5,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile5 != null) {
                        photoMobile2 = cropMobile5;
                      }
                    } else if (photoMobile3 == null &&
                        widget._currentUser.photo3 == null) {
                      cropMobile5 = await cropImageMobile(
                        image: pickMobile5,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile5 != null) {
                        photoMobile3 = cropMobile5;
                      }
                    } else if (photoMobile4 == null &&
                        widget._currentUser.photo4 == null) {
                      cropMobile5 = await cropImageMobile(
                        image: pickMobile5,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile5 != null) {
                        photoMobile4 = cropMobile5;
                      }
                    } else {
                      cropMobile5 = await cropImageMobile(
                        image: pickMobile5,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile5 != null) {
                        photoMobile5 = cropMobile5;
                      }
                    }
                    setState(() {
                      readOnly = false;
                    });
                  }
                }
              },
              child: (photoWeb5 != null || photoMobile5 != null) //pickされたなら
                  ? //pickされたなら
                  Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: (web)
                              ? Image.memory(photoWeb5)
                              : Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(photoMobile5),
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                if (web) {
                                  if (photoWeb6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoWeb5 = null;
                                  } else {
                                    photoWeb5 = photoWeb6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoWeb6 = null;
                                  widget._currentUser.photo6 = null;
                                  cropWeb5 = null;
                                  update = true;
                                } else if (android || ios) {
                                  if (photoMobile6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoMobile5 = null;
                                  } else {
                                    photoMobile5 = photoMobile6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoMobile6 = null;
                                  widget._currentUser.photo6 = null;
                                  pickMobile5 = null;
                                  update = true;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : //pickされてないなら
                  Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: (web)
                              ? HtmlElementView(
                                  viewType: imageUrl,
                                )
                              : ShowImageFromURL(
                                  photoURL: widget._currentUser.photo5,
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                if (web) {
                                  if (photoWeb6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoWeb5 = null;
                                  } else {
                                    photoWeb5 = photoWeb6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoWeb6 = null;
                                  widget._currentUser.photo6 = null;
                                  cropWeb5 = null;
                                  update = true;
                                } else if (android || ios) {
                                  if (photoMobile6 == null) {
                                    widget._currentUser.photo5 =
                                        widget._currentUser.photo6;
                                    photoMobile5 = null;
                                  } else {
                                    photoMobile5 = photoMobile6;
                                    widget._currentUser.photo5 = null;
                                  }
                                  photoMobile6 = null;
                                  widget._currentUser.photo6 = null;
                                  pickMobile5 = null;
                                  update = true;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

  Widget pickCrop6() {
    Size size = MediaQuery.of(context).size;
    String imageUrl;
    if (web) {
      imageUrl = widget._currentUser.photo6;
      ui.platformViewRegistry.registerViewFactory(
        imageUrl,
        (int _) => html.ImageElement()..src = imageUrl,
      );
    }
    return Container(
      height: size.width * 0.45,
      width: size.width * 0.31,
      child: (widget._currentUser.photo6 == null)
          ? GestureDetector(
              //photoが登録されていないなら
              onTap: () async {
                if (web) {
                  cropWeb6 = await pickAndCrop(
                    context: context,
                    mounted: mounted,
                    ratio: 2 / 3,
                  );
                  if (cropWeb6 != null) {
                    update = true;
                    setState(() {
                      if (photoWeb6 != null ||
                          widget._currentUser.photo6 != null) {
                        photoWeb6 = cropWeb6;
                        widget._currentUser.photo6 = null;
                      } else if (photoWeb1 == null &&
                          widget._currentUser.photo1 == null) {
                        photoWeb1 = cropWeb6;
                      } else if (photoWeb2 == null &&
                          widget._currentUser.photo2 == null) {
                        photoWeb2 = cropWeb6;
                      } else if (photoWeb3 == null &&
                          widget._currentUser.photo3 == null) {
                        photoWeb3 = cropWeb6;
                      } else if (photoWeb4 == null &&
                          widget._currentUser.photo4 == null) {
                        photoWeb4 = cropWeb6;
                      } else if (photoWeb5 == null &&
                          widget._currentUser.photo5 == null) {
                        photoWeb5 = cropWeb6;
                      } else {
                        photoWeb6 = cropWeb6;
                      }
                    });
                  }
//                  pickWeb6 = await ImagePickerWeb.getImage(
//                      outputType: ImageType.bytes);
//                  if (pickWeb6 != null) {
//                    setState(() {
//                      update = true;
//                      readOnly = true;
//                    });
//                    //pickされたなら
//                    if (photoWeb6 != null ||
//                        widget._currentUser.photo6 != null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb6,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb6 = data;
//                              widget._currentUser.photo6 = null;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else if (photoWeb1 == null &&
//                        widget._currentUser.photo1 == null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb6,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb1 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else if (photoWeb2 == null &&
//                        widget._currentUser.photo2 == null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb6,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb2 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else if (photoWeb3 == null &&
//                        widget._currentUser.photo3 == null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb6,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb3 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else if (photoWeb4 == null &&
//                        widget._currentUser.photo4 == null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb6,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb4 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else if (photoWeb5 == null &&
//                        widget._currentUser.photo5 == null) {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb6,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb5 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    } else {
//                      ImageCropping.cropImage(
//                        context,
//                        pickWeb6,
//                        () {},
//                        () {},
//                        (data) {
//                          setState(
//                            () {
//                              photoWeb6 = data;
//                            },
//                          );
//                        },
//                        selectedImageRatio: ImageRatio.RATIO_3_2,
//                        visibleOtherAspectRatios: false,
//                        squareCircleColor: pink,
//                      );
//                    }
//                    setState(() {
//                      readOnly = false;
//                    });
//                  }
                } else if (android || ios) {
                  FilePickerResult result =
                      await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result != null) {
                    pickMobile6 = File(result.files.single.path);
                    setState(() {
                      update = true;
                      readOnly = true;
                    });
                    //pickされたなら
                    if (photoMobile6 != null ||
                        widget._currentUser.photo6 != null) {
                      cropMobile6 = await cropImageMobile(
                        image: pickMobile6,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile6 != null) {
                        photoMobile6 = cropMobile6;
                        widget._currentUser.photo6 = null;
                      }
                    } else if (photoMobile1 == null &&
                        widget._currentUser.photo1 == null) {
                      cropMobile6 = await cropImageMobile(
                        image: pickMobile6,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile6 != null) {
                        photoMobile1 = cropMobile6;
                      }
                    } else if (photoMobile2 == null &&
                        widget._currentUser.photo2 == null) {
                      cropMobile6 = await cropImageMobile(
                        image: pickMobile6,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile6 != null) {
                        photoMobile2 = cropMobile6;
                      }
                    } else if (photoMobile3 == null &&
                        widget._currentUser.photo3 == null) {
                      cropMobile6 = await cropImageMobile(
                        image: pickMobile6,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile6 != null) {
                        photoMobile3 = cropMobile6;
                      }
                    } else if (photoMobile4 == null &&
                        widget._currentUser.photo4 == null) {
                      cropMobile6 = await cropImageMobile(
                        image: pickMobile6,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile6 != null) {
                        photoMobile4 = cropMobile6;
                      }
                    } else if (photoMobile5 == null &&
                        widget._currentUser.photo5 == null) {
                      cropMobile6 = await cropImageMobile(
                        image: pickMobile6,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile6 != null) {
                        photoMobile5 = cropMobile6;
                      }
                    } else {
                      cropMobile6 = await cropImageMobile(
                        image: pickMobile6,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile6 != null) {
                        photoMobile6 = cropMobile6;
                      }
                    }
                    setState(() {
                      readOnly = false;
                    });
                  }
                }
              },
              child: (photoWeb6 != null || photoMobile6 != null) //pickされたなら
                  ? Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: Image(
                            fit: BoxFit.cover,
                            image: FileImage(photoMobile6),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                if (web) {
                                  photoWeb6 = null;
                                  widget._currentUser.photo6 = null;
                                  cropWeb5 = null;
                                  update = true;
                                } else if (android || ios) {
                                  photoMobile6 = null;
                                  widget._currentUser.photo6 = null;
                                  pickMobile5 = null;
                                  update = true;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: <Widget>[
                        Container(
                          color: veryLightGrey,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.add,
                            color: pink,
                            size: size.width * 0.07,
                          ),
                        ),
                      ],
                    ),
            )
          : GestureDetector(
//photoが登録されているなら
              onTap: () async {
                if (web) {
                  cropWeb6 = await pickAndCrop(
                    context: context,
                    mounted: mounted,
                    ratio: 2 / 3,
                  );
                  if (cropWeb6 != null) {
                    update = true;
                    setState(() {
                      if (photoWeb6 != null ||
                          widget._currentUser.photo6 != null) {
                        photoWeb6 = cropWeb6;
                        widget._currentUser.photo6 = null;
                      } else if (photoWeb1 == null &&
                          widget._currentUser.photo1 == null) {
                        photoWeb1 = cropWeb6;
                      } else if (photoWeb2 == null &&
                          widget._currentUser.photo2 == null) {
                        photoWeb2 = cropWeb6;
                      } else if (photoWeb3 == null &&
                          widget._currentUser.photo3 == null) {
                        photoWeb3 = cropWeb6;
                      } else if (photoWeb4 == null &&
                          widget._currentUser.photo4 == null) {
                        photoWeb4 = cropWeb6;
                      } else if (photoWeb5 == null &&
                          widget._currentUser.photo5 == null) {
                        photoWeb5 = cropWeb6;
                      } else {
                        photoWeb6 = cropWeb6;
                      }
                    });
                  }
                } else if (android || ios) {
                  FilePickerResult result =
                      await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result != null) {
                    pickMobile6 = File(result.files.single.path);
                    setState(() {
                      update = true;
                      readOnly = true;
                    });
                    //pickされたなら
                    if (photoMobile6 != null ||
                        widget._currentUser.photo6 != null) {
                      cropMobile6 = await cropImageMobile(
                        image: pickMobile6,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile6 != null) {
                        photoMobile6 = cropMobile6;
                        widget._currentUser.photo6 = null;
                      }
                    } else if (photoMobile1 == null &&
                        widget._currentUser.photo1 == null) {
                      cropMobile6 = await cropImageMobile(
                        image: pickMobile6,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile6 != null) {
                        photoMobile1 = cropMobile6;
                      }
                    } else if (photoMobile2 == null &&
                        widget._currentUser.photo2 == null) {
                      cropMobile6 = await cropImageMobile(
                        image: pickMobile6,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile6 != null) {
                        photoMobile2 = cropMobile6;
                      }
                    } else if (photoMobile3 == null &&
                        widget._currentUser.photo3 == null) {
                      cropMobile6 = await cropImageMobile(
                        image: pickMobile6,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile6 != null) {
                        photoMobile3 = cropMobile6;
                      }
                    } else if (photoMobile4 == null &&
                        widget._currentUser.photo4 == null) {
                      cropMobile6 = await cropImageMobile(
                        image: pickMobile6,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile6 != null) {
                        photoMobile4 = cropMobile6;
                      }
                    } else if (photoMobile5 == null &&
                        widget._currentUser.photo5 == null) {
                      cropMobile6 = await cropImageMobile(
                        image: pickMobile6,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile6 != null) {
                        photoMobile5 = cropMobile6;
                      }
                    } else {
                      cropMobile6 = await cropImageMobile(
                        image: pickMobile6,
                        width: 1.0,
                        height: 1.5,
                      );
                      if (cropMobile6 != null) {
                        photoMobile6 = cropMobile6;
                      }
                    }
                    setState(() {
                      readOnly = false;
                    });
                  }
                }
              },
              child: (photoWeb6 != null || photoMobile6 != null) //pickされたなら
                  ? //pickされたなら
                  Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: Image(
                            fit: BoxFit.cover,
                            image: FileImage(photoMobile6),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                if (web) {
                                  photoWeb6 = null;
                                  widget._currentUser.photo6 = null;
                                  cropWeb5 = null;
                                  update = true;
                                } else if (android || ios) {
                                  photoMobile6 = null;
                                  widget._currentUser.photo6 = null;
                                  pickMobile5 = null;
                                  update = true;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : //pickされてないなら
                  Stack(
                      children: <Widget>[
                        Container(
                          height: size.width * 0.45,
                          width: size.width * 0.31,
                          child: (web)
                              ? HtmlElementView(
                                  viewType: imageUrl,
                                )
                              : ShowImageFromURL(
                                  photoURL: widget._currentUser.photo6,
                                ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: circleButton(
                            icon: Icons.close,
                            color: pink,
                            size: size.width * 0.07,
                            onPressed: () {
                              setState(() {
                                if (web) {
                                  photoWeb6 = null;
                                  widget._currentUser.photo6 = null;
                                  cropWeb5 = null;
                                  update = true;
                                } else if (android || ios) {
                                  photoMobile6 = null;
                                  widget._currentUser.photo6 = null;
                                  pickMobile5 = null;
                                  update = true;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

//  Widget editProfilePhoto7() {
//    return Container(
//      height: 120.0,
//      width: 120.0,
//      child: (widget._currentUser.photo7 == null)
//          ? GestureDetector(
//              //photoが登録されていないなら
//              onTap: () async {
//                getPick7 = await FilePicker.getFile(type: FileType.image);
//
//                if (getPick7 != null) {
//                  //pickされたなら
//                  setState(() {
//                    photo7 = getPick7;
//                    print('phot: $photo7');
//                  });
//                }
//              },
//              child: (getPick7 != null) //pickされたなら
//                  ? Stack(
//                      children: <Widget>[
//                        Container(
//                          height: 120.0,
//                          width: 120.0,
//                          child: Image(
//                            fit: BoxFit.cover,
//                            image: FileImage(photo7),
//                          ),
//                        ),
//                        Align(
//                          alignment: Alignment.bottomRight,
//                          child: RoundIconButton.tiny(
//                            icon: Icons.close,
//                            iconColor: pink,
//                            onPressed: () {
//                              setState(() {
//                                widget._currentUser.photo7 = null;
//                                photo7 = null;
//                                getPick7 = null;
//                                update = true;
//                              });
//                            },
//                          ),
//                        ),
//                      ],
//                    )
//            )
//          : GestureDetector(
////photoが登録されているなら
//              onTap: () async {
//                getPick7 = await FilePicker.getFile(type: FileType.image);
//                if (getPick7 != null) {
//                  //pickされたなら
//                  setState(() {
//                    print('photopre: $photo7');
//                    photo7 = getPick7;
//                    print('photo: $photo7');
//                  });
//                }
//              },
//              child: (getPick7 != null) //pickされたなら
//                  ? //pickされたなら
//                  Stack(
//                      children: <Widget>[
//                        Container(
//                          height: 120.0,
//                          width: 120.0,
//                          child: Image(
//                            fit: BoxFit.cover,
//                            image: FileImage(photo7),
//                          ),
//                        ),
//                        Align(
//                          alignment: Alignment.bottomRight,
//                          child: RoundIconButton.tiny(
//                            icon: Icons.close,
//                            iconColor: pink,
//                            onPressed: () {
//                              setState(() {
//                                widget._currentUser.photo7 = null;
//                                photo7 = null;
//                                getPick7 = null;
//                                update = true;
//                              });
//                            },
//                          ),
//                        ),
//                      ],
//                    )
//                  : //pickされてないなら
//                  Stack(
//                      children: <Widget>[
//                        Container(
//                          height: 120.0,
//                          width: 120.0,
//                          child: PhotoWidget(
//                            photoLink: widget._currentUser.photo7,
//                          ),
//                        ),
//                        Align(
//                          alignment: Alignment.bottomRight,
//                          child: RoundIconButton.tiny(
//                            icon: Icons.close,
//                            iconColor: pink,
//                            onPressed: () {
//                              setState(() {
//                                widget._currentUser.photo7 = null;
//                                photo7 = null;
//                                getPick7 = null;
//                                update = true;
//                              });
//                            },
//                          ),
//                        ),
//                      ],
//                    ),
//            ),
//    );
//  }
//
//  Widget editProfilePhoto8() {
//    return Container(
//      height: 120.0,
//      width: 120.0,
//      child: (widget._currentUser.photo8 == null)
//          ? GestureDetector(
//              //photoが登録されていないなら
//              onTap: () async {
//                getPick8 = await FilePicker.getFile(type: FileType.image);
//
//                if (getPick8 != null) {
//                  //pickされたなら
//                  setState(() {
//                    photo8 = getPick8;
//                    print('phot: $photo8');
//                  });
//                }
//              },
//              child: (getPick8 != null) //pickされたなら
//                  ? Stack(
//                      children: <Widget>[
//                        Container(
//                          height: 120.0,
//                          width: 120.0,
//                          child: Image(
//                            fit: BoxFit.cover,
//                            image: FileImage(photo8),
//                          ),
//                        ),
//                        Align(
//                          alignment: Alignment.bottomRight,
//                          child: RoundIconButton.tiny(
//                            icon: Icons.close,
//                            iconColor: pink,
//                            onPressed: () {
//                              setState(() {
//                                widget._currentUser.photo8 = null;
//                                photo8 = null;
//                                getPick8 = null;
//                                update = true;
//                              });
//                            },
//                          ),
//                        ),
//                      ],
//                    )
//            )
//          : GestureDetector(
////photoが登録されているなら
//              onTap: () async {
//                getPick8 = await FilePicker.getFile(type: FileType.image);
//                if (getPick8 != null) {
//                  //pickされたなら
//                  setState(() {
//                    print('photopre: $photo8');
//                    photo8 = getPick8;
//                    print('photo: $photo8');
//                  });
//                }
//              },
//              child: (getPick8 != null) //pickされたなら
//                  ? //pickされたなら
//                  Stack(
//                      children: <Widget>[
//                        Container(
//                          height: 120.0,
//                          width: 120.0,
//                          child: Image(
//                            fit: BoxFit.cover,
//                            image: FileImage(photo8),
//                          ),
//                        ),
//                        Align(
//                          alignment: Alignment.bottomRight,
//                          child: RoundIconButton.tiny(
//                            icon: Icons.close,
//                            iconColor: pink,
//                            onPressed: () {
//                              setState(() {
//                                widget._currentUser.photo8 = null;
//                                photo8 = null;
//                                getPick8 = null;
//                                update = true;
//                              });
//                            },
//                          ),
//                        ),
//                      ],
//                    )
//                  : //pickされてないなら
//                  Stack(
//                      children: <Widget>[
//                        Container(
//                          height: 120.0,
//                          width: 120.0,
//                          child: PhotoWidget(
//                            photoLink: widget._currentUser.photo8,
//                          ),
//                        ),
//                        Align(
//                          alignment: Alignment.bottomRight,
//                          child: RoundIconButton.tiny(
//                            icon: Icons.close,
//                            iconColor: pink,
//                            onPressed: () {
//                              setState(() {
//                                widget._currentUser.photo8 = null;
//                                photo8 = null;
//                                getPick8 = null;
//                                update = true;
//                              });
//                            },
//                          ),
//                        ),
//                      ],
//                    ),
//            ),
//    );
//  }
//
//  Widget editProfilePhoto9() {
//    return Container(
//      height: 120.0,
//      width: 120.0,
//      child: (widget._currentUser.photo9 == null)
//          ? GestureDetector(
//              //photoが登録されていないなら
//              onTap: () async {
//                getPick9 = await FilePicker.getFile(type: FileType.image);
//
//                if (getPick9 != null) {
//                  //pickされたなら
//                  setState(() {
//                    photo9 = getPick9;
//                    print('phot: $photo9');
//                  });
//                }
//              },
//              child: (getPick9 != null) //pickされたなら
//                  ? Stack(
//                      children: <Widget>[
//                        Container(
//                          height: 120.0,
//                          width: 120.0,
//                          child: Image(
//                            fit: BoxFit.cover,
//                            image: FileImage(photo9),
//                          ),
//                        ),
//                        Align(
//                          alignment: Alignment.bottomRight,
//                          child: RoundIconButton.tiny(
//                            icon: Icons.close,
//                            iconColor: pink,
//                            onPressed: () {
//                              setState(() {
//                                widget._currentUser.photo9 = null;
//                                photo9 = null;
//                                getPick9 = null;
//                                update = true;
//                              });
//                            },
//                          ),
//                        ),
//                      ],
//                    )
//            )
//          : GestureDetector(
////photoが登録されているなら
//              onTap: () async {
//                getPick9 = await FilePicker.getFile(type: FileType.image);
//                if (getPick9 != null) {
//                  //pickされたなら
//                  setState(() {
//                    print('photopre: $photo9');
//                    photo9 = getPick9;
//                    print('photo: $photo9');
//                  });
//                }
//              },
//              child: (getPick9 != null) //pickされたなら
//                  ? //pickされたなら
//                  Stack(
//                      children: <Widget>[
//                        Container(
//                          height: 120.0,
//                          width: 120.0,
//                          child: Image(
//                            fit: BoxFit.cover,
//                            image: FileImage(photo9),
//                          ),
//                        ),
//                        Align(
//                          alignment: Alignment.bottomRight,
//                          child: RoundIconButton.tiny(
//                            icon: Icons.close,
//                            iconColor: pink,
//                            onPressed: () {
//                              setState(() {
//                                widget._currentUser.photo9 = null;
//                                photo9 = null;
//                                getPick9 = null;
//                                update = true;
//                              });
//                            },
//                          ),
//                        ),
//                      ],
//                    )
//                  : //pickされてないなら
//                  Stack(
//                      children: <Widget>[
//                        Container(
//                          height: 120.0,
//                          width: 120.0,
//                          child: PhotoWidget(
//                            photoLink: widget._currentUser.photo9,
//                          ),
//                        ),
//                        Align(
//                          alignment: Alignment.bottomRight,
//                          child: RoundIconButton.tiny(
//                            icon: Icons.close,
//                            iconColor: pink,
//                            onPressed: () {
//                              setState(() {
//                                widget._currentUser.photo9 = null;
//                                photo9 = null;
//                                getPick9 = null;
//                                update = true;
//                              });
//                            },
//                          ),
//                        ),
//                      ],
//                    ),
//            ),
//    );
//  }
}
