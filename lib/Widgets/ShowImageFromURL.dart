import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:Keioboys/consts.dart';

//behotu@fukurou.ch
class ShowImageFromURL extends StatelessWidget {
  final String photoURL;
  ShowImageFromURL({
    this.photoURL,
  });

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      photoURL,
      fit: BoxFit.cover,
      cache: false,
//      cache: true,
      enableSlideOutPage: true,
      filterQuality: FilterQuality.high,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(pink),
              ),
            );
            break;
          case LoadState.completed:
            return null;
            break;
          case LoadState.failed:
            return GestureDetector(
              child: Center(
                child: Container(),
              ),
              onTap: () {
                state.reLoadImage();
              },
            );
            break;
        }

        return Text("");
      },
    );
  }
}
