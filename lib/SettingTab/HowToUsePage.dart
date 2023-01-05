import 'package:Keioboys/Auth/SignUp/SignUp1.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:Keioboys/Widgets/SlideRoute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seo_renderer/seo_renderer.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../consts.dart';

class HowToUsePage extends StatefulWidget {
  @override
  _HowToUsePageState createState() => _HowToUsePageState();
}

class _HowToUsePageState extends State<HowToUsePage> {
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: '5bvqKL0o0sc',
    params: YoutubePlayerParams(
      startAt: Duration(seconds: 0),
      showControls: true,
      autoPlay: false,
      showFullscreenButton: true,
    ),
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        brightness: Brightness.light,
        title: Text(
          'Keioboysの説明書',
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
          child: Padding(
            padding: EdgeInsets.all(
              size.width * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                YoutubePlayerIFrame(
                  controller: _controller,
                  aspectRatio: 16 / 9,
                ),
                SizedBox(
                  height: size.width * 0.04,
                ),
                Center(
                  child: Text(
                    'Keioboysとは',
                    style: TextStyle(
                      color: pink,
                      fontSize: size.width * 0.07,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.width * 0.04,
                ),
                Text(
                  'Keioboysは友達や恋人を探すことができる無料のマッチングアプリです。',
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.04,
                  ),
                ),
                Text(
                  '男性は慶應・早稲田の学生、OBのみが利用できます。女性は制限がありません。',
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.04,
                  ),
                ),
                Text(
                  'お互いにLIKEしてマッチするとメッセージをすることができます。',
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.04,
                  ),
                ),
                SizedBox(
                  height: size.width * 0.06,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      final UserFB _userFB = UserFB();
                      Navigator.of(context).push(
                        slideRoute(
                          SignUp1(userFB: _userFB),
                        ),
                      );
                    },
                    child: Container(
                      width: size.width * 0.8,
                      height: size.height * 0.06,
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
                          "アカウントを作成",
                          style: TextStyle(
                            fontSize: size.width * 0.05,
                            color: white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.width * 0.05,
                ),
                Center(
                  child: Text(
                    'カードをスワイプ',
                    style: TextStyle(
                      color: pink,
                      fontSize: size.width * 0.07,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.width * 0.04,
                ),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.favorite,
                          color: pink,
                          size: size.width * 0.05,
                        ),
                      ),
                      TextSpan(text: 'ボタンまたはカードを右スワイプで『LIKE』を送れます。'),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.star,
                          color: Colors.orangeAccent,
                          size: size.width * 0.05,
                        ),
                      ),
                      TextSpan(
                          text:
                              'ボタンまたはカードを上スワイプで『SUPER LIKE』を送れます。『SUPER LIKE』を送るとあなたの名前に'),
                      WidgetSpan(
                        child: Icon(
                          Icons.star,
                          color: Colors.orangeAccent,
                          size: size.width * 0.05,
                        ),
                      ),
                      TextSpan(text: 'が付き、相手に伝えることができます。'),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.clear,
                          color: Colors.blueAccent,
                          size: size.width * 0.05,
                        ),
                      ),
                      TextSpan(
                          text: 'ボタンまたはカードを左スワイプでSKIPを選べます。その相手とはマッチできません。'),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.width * 0.07,
                ),
                Center(
                  child: Text(
                    '画面の説明',
                    style: TextStyle(
                      color: pink,
                      fontSize: size.width * 0.07,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.width * 0.04,
                ),
                Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/explanation1.jpg',
                      width: size.width * 0.3,
                      height: size.height * 0.3,
                    ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Image.asset(
                      'assets/images/explanation2.jpg',
                      width: size.width * 0.3,
                      height: size.height * 0.3,
                    ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Image.asset(
                      'assets/images/explanation3.jpg',
                      width: size.width * 0.3,
                      height: size.height * 0.3,
                    ),
                  ],
                ),
                SizedBox(
                  height: size.width * 0.04,
                ),
                Text(
                  '①新しいカードを探して『LIKE』を送れます。',
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.04,
                  ),
                ),
                Text(
                  '②すでにやりとりしている人にメッセージを送れます。また、マッチの解除を行えます。',
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.04,
                  ),
                ),
                Text(
                  '③マッチした人を確認してメッセージを送れます。',
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.04,
                  ),
                ),
                Text(
                  '④あなたを『LIKE』した人を確認して『LIKE』を返したりメッセージを送ったりできます。',
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.04,
                  ),
                ),
                Text(
                  '⑤自分のプロフィールを確認できます。',
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.04,
                  ),
                ),
                Text(
                  '⑥Keioboysの使い方を確認できます。',
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.04,
                  ),
                ),
                Text(
                  '⑦各種設定を変更したりお知らせを確認したりできます。',
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.04,
                  ),
                ),
                Text(
                  '⑧プロフィールの編集を行えます。',
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.04,
                  ),
                ),
                SizedBox(
                  height: size.width * 0.07,
                ),
                Center(
                  child: Text(
                    '安心・安全に使える',
                    style: TextStyle(
                      color: pink,
                      fontSize: size.width * 0.07,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.width * 0.04,
                ),
                Text(
                  '１．男性は早慶のメールアドレス必須',
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.04,
                  ),
                ),
                Text(
                  '２．実名は表示されません',
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.04,
                  ),
                ),
                Text(
                  '３．悪質ユーザーの報告機能',
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.04,
                  ),
                ),
                Text(
                  '※警察署からの許可・監視の下、適切に運営しております。インターネット異性紹介事業登録番号：三田21-098162',
                  style: TextStyle(
                    color: black87,
                    fontSize: size.width * 0.035,
                  ),
                ),
                SizedBox(
                  height: size.width * 0.06,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      final UserFB _userFB = UserFB();
                      Navigator.of(context).push(
                        slideRoute(
                          SignUp1(userFB: _userFB),
                        ),
                      );
                    },
                    child: Container(
                      width: size.width * 0.8,
                      height: size.height * 0.06,
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
                          "アカウントを作成",
                          style: TextStyle(
                            fontSize: size.width * 0.05,
                            color: white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.width * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
