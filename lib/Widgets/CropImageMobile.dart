import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:Keioboys/consts.dart';

Future cropImageMobile({File image, double height, double width}) async {
  File croppedImage = await ImageCropper.cropImage(
    sourcePath: image.path,
    aspectRatio: CropAspectRatio(
      ratioX: width,
//      ratioX: 1.0,
      ratioY: height,
//      ratioY: 1.5,
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
