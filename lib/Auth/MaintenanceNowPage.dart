import 'package:flutter/material.dart';
import 'package:Keioboys/consts.dart';

class MaintenanceNowPage extends StatefulWidget {
  final String maintenanceText;

  MaintenanceNowPage({
    this.maintenanceText,
  });

  @override
  _MaintenanceNowPageState createState() => _MaintenanceNowPageState();
}

class _MaintenanceNowPageState extends State<MaintenanceNowPage> {
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
            'メンテナンスのお知らせ',
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
                size.width * 0.05,
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    'ただいまメンテナンス中のためアプリを利用できません。ご迷惑おかけすること深くお詫び申し上げます。',
                    style: TextStyle(
                      color: black87,
                      fontSize: size.width * 0.05,
                    ),
                  ),
                  SizedBox(
                    height: size.width * 0.05,
                  ),
                  (widget.maintenanceText != null)
                      ? Text(
                          '${widget.maintenanceText}',
                          style: TextStyle(
                            color: black87,
                            fontSize: size.width * 0.05,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
