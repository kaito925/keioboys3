import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:Keioboys/consts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsOfServicePage extends StatefulWidget {
  @override
  _TermsOfServicePageState createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final Completer _controller = Completer();

  var connectionStatus;

  num position = 1;
  final key = UniqueKey();

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }

  // インターネット接続チェック
  Future check() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connectionStatus = true;
      }
    } on SocketException catch (_) {
      connectionStatus = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: check(), // Future or nullを取得
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            brightness: Brightness.light,
            title: Text(
              '利用規約',
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
          body: (web)
              ? SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SafeArea(
                      child: Image.asset(
                    'assets/images/ts.PNG',
                    width: size.width * 0.98,
                  )))
              : (connectionStatus == true)
                  ? IndexedStack(
                      index: position,
                      children: [
                        WebView(
                          initialUrl:
                              'https://sites.google.com/view/keioboys-ts',
                          javascriptMode: JavascriptMode.unrestricted,
                          // JavaScriptを有効化
                          onWebViewCreated:
                              (WebViewController webViewController) {
                            _controller.complete(webViewController);
                          },
                          key: key,
                          onPageFinished: doneLoading,
                          // indexを０にしてWebViewを表示
                          onPageStarted:
                              startLoading, // indexを1にしてプログレスインジケーターを表示
                        ),
                        // プログレスインジケーターを表示
                        Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: pink,
                            ),
                          ),
                        ),
                      ],
                    )
                  // インターネットに接続されていない場合の処理
                  : SafeArea(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: size.height * 0.05,
                          ),
                          child: Text(
                            'インターネットに接続されていません。',
                            style: TextStyle(
                              color: black87,
                              fontSize: size.width * 0.05,
                            ),
                          ),
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
