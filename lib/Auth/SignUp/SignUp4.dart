import 'dart:io';
import 'dart:typed_data';

import 'package:Keioboys/Auth/SignUp/SignUpPage.dart';
import 'package:Keioboys/Widgets/CropImageMobile.dart';
import 'package:Keioboys/Widgets/PickCrop.dart';
import 'package:Keioboys/Widgets/SlideRoute.dart';
import 'package:file_picker/file_picker.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:Keioboys/consts.dart';

String gender;

class SignUp4 extends StatefulWidget {
  final UserFB _userFB;
  final String name;
  final DateTime birthday;
  final String gender;

  SignUp4({
    @required UserFB userFB,
    @required this.name,
    @required this.birthday,
    @required this.gender,
  })  : assert(userFB != null),
        _userFB = userFB;

  @override
  _SignUp4State createState() => _SignUp4State();
}

class _SignUp4State extends State<SignUp4> {
  File photoMobile;
  Uint8List photoWeb;
  UserFB get userFB => widget._userFB;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        brightness: Brightness.light,
        title: Text(
          'アカウント作成 (4/5)',
          style: TextStyle(
            color: pink,
          ),
        ),
        iconTheme: IconThemeData(
          color: pink,
        ),
        backgroundColor: white,
//        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.08,
                ),
                Text(
                  "プロフィール写真",
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.1,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.08,
                ),
                pickCrop(),
                SizedBox(
                  height: size.height * 0.03,
                ),
                (android)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '※トリミングできない場合は',
                            style: TextStyle(
                              color: black87,
                              fontSize: size.width * 0.04,
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              'コチラ',
                              style: TextStyle(
                                color: pink,
                                fontSize: size.width * 0.04,
                              ),
                            ),
                            onTap: () async {
                              FilePickerResult result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.image,
                              );

                              if (result != null) {
                                photoMobile =
                                    File.fromRawPath(result.files.single.bytes);
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      )
                    : SizedBox(
                        height: size.height * 0.02,
                      ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                GestureDetector(
                  onTap: () {
                    if (web) {
                      if (photoWeb != null) {
                        Navigator.of(context).push(
                          slideRoute(
                            SignUpPage(
                              userFB: userFB,
                              name: widget.name,
                              birthday: widget.birthday,
                              gender: widget.gender,
                              photoWeb: photoWeb,
//                            photo: photo,
                            ),
                          ),
                        );
                      } else {
                        Flushbar(
                          message: "プロフィール写真を登録してください。",
                          backgroundColor: pink,
                          duration: Duration(seconds: 3),
                        )..show(context);
                      }
                    } else if (android || ios) {
                      if (photoMobile != null) {
                        Navigator.of(context).push(
                          slideRoute(
                            SignUpPage(
                              userFB: userFB,
                              name: widget.name,
                              birthday: widget.birthday,
                              gender: widget.gender,
                              photoMobile: photoMobile,
                            ),
                          ),
                        );
                      } else {
                        Flushbar(
                          message: "プロフィール写真を登録してください。",
                          backgroundColor: pink,
                          duration: Duration(seconds: 3),
                        )..show(context);
                      }
                    }
                  },
                  child: Container(
                    width: size.width * 0.7,
                    height: size.width * 0.1,
                    decoration: BoxDecoration(
                      color: pink,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Text(
                        "次へ",
                        style: TextStyle(
                          color: white,
                          fontSize: size.width * 0.06,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pickCrop() {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.width * 0.72,
      width: size.width * 0.48,
      child: GestureDetector(
        onTap: () async {
          if (web) {
            photoWeb = await pickAndCrop(
              context: context,
              mounted: mounted,
              ratio: 2 / 3,
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
                width: 1.0,
                height: 1.5,
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
                    height: size.width * 0.72,
                    width: size.width * 0.48,
//                    child: image,
//                    child: Image(
//                      fit: BoxFit.cover,
//                      image: FileImage(photo),
//                    ),
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

//  Future<void> selectImage() async {
//    final picker = ImagePicker();
//    XFile pickedFile = await picker.pickImage(source: ImageSource.gallery);
//    if (mounted && pickedFile != null) {
//      var result = await Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) => CropperScreen(
//              pickedFile.path,
////              imagePath: pickedFile.path,
////              ratio: 2 / 3,
//            ),
//          ));
//      if (result != null) {
//        photoWeb = await getBlobData(result);
////                  croppedProfileImage = await getBlobData(result);
////                  if (mounted) {
//        setState(() {});
////                  }
//      }
//    }
//  }
}
