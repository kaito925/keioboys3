import 'package:flutter/material.dart';
import '../consts.dart';
import 'package:url_launcher/url_launcher.dart';

class RequireUpdatePage extends StatefulWidget {
  @override
  _RequireUpdatePageState createState() => _RequireUpdatePageState();
}

class _RequireUpdatePageState extends State<RequireUpdatePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          brightness: Brightness.light,
          automaticallyImplyLeading: false,
          title: Text(
            'アップデートのお知らせ',
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                  ),
                  child: Text(
                    '新しいバージョンのアプリが利用可能です。',
                    style: TextStyle(
                      color: black87,
                      fontSize: size.width * 0.045,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.02,
                    right: size.width * 0.02,
                  ),
                  child: Text(
                    'アプリストアからアップデートしてください。',
                    style: TextStyle(
                      color: black87,
                      fontSize: size.width * 0.045,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.58,
                ),
                Center(
                  child: GestureDetector(
                    child: Container(
                      width: size.width * 0.7,
                      height: size.height * 0.06,
                      decoration: BoxDecoration(
                        color: pink,
                        borderRadius: BorderRadius.circular(
                          100,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "アップデート",
                          style: TextStyle(
                            fontSize: size.width * 0.05,
                            color: white,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      if (android) {
                        launch(
                            'https://play.google.com/store/apps/details?id=com.stars_matching.com');
                      } else if (ios) {
                        launch(
                            'https://itunes.apple.com/jp/app/id1535177691?mt=8');
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
