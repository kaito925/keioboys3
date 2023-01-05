import 'package:flutter/material.dart';
import 'package:Keioboys/FB/UserFB.dart';
import '../consts.dart';

class PremiumPage extends StatefulWidget {
  final UserFB _userFB;
  final String _userId;

  PremiumPage({
    Key key,
    @required UserFB userFB,
    String userId,
  })  : assert(userFB != null),
        _userFB = userFB,
        _userId = userId,
        super(key: key);

  @override
  _PremiumPageState createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  UserFB get _userFB => widget._userFB;

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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        brightness: Brightness.light,
        title: Text(
          'プレミアムプラン',
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
            children: <Widget>[
              FlatButton(
                child: Text('シルバーメンバー'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("シルバーメンバー"),
                        content: Container(
                          width: size.width * 0.9,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[],
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("キャンセル"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          FlatButton(
                            child: Text("購入"),
                            onPressed: () async {},
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
