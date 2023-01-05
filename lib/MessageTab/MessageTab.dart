import 'package:Keioboys/Widgets/UserData.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:Keioboys/MessageTab/MatchPage.dart';
import 'package:Keioboys/MessageTab/LikedPage.dart';
import 'package:Keioboys/MessageTab/MessageListPage.dart';
import 'package:flutter/material.dart';
import 'package:Keioboys/consts.dart';
import 'package:Keioboys/MessageTab/AgeVerificationPage.dart';

class MessageTab extends StatefulWidget {
  final UserData currentUser;
  final UserFB userFB;

  MessageTab({
    this.currentUser,
    this.userFB,
  });

  @override
  _MessageTabState createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab>
    with AutomaticKeepAliveClientMixin<MessageTab> {
  PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  Widget _buildMessageAppBar() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
//        new Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildTabItem(title: "メッセージ", position: 0),
//            new Container(
//              height: size.height * 0.05,
//              width: size.height * 0.0012,
//              color: lightGrey,
////              color: Colors.grey.withOpacity(0.5),
//            ),
            _buildTabItem(title: "新しいマッチ", position: 1),
//            new Container(
//              height: size.height * 0.05,
//              width: size.height * 0.0012,
//              color: lightGrey,
////              color: Colors.grey.withOpacity(0.5),
//            ),
            _buildTabItem(title: "あなたをLIKE", position: 2),
          ],
        ),
//        new Divider()
      ],
    );
  }

  Widget _buildTabsLayout() {
    return Flexible(
      child: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: _onPageChange,
        children: <Widget>[
          MessageListPage(
            currentUser: widget.currentUser,
          ),
          MatchPage(
            currentUser: widget.currentUser,
          ),
          LikedPage(
            currentUser: widget.currentUser,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: <Widget>[
          _buildMessageAppBar(),
          _buildTabsLayout(),
        ],
      ),
    );
  }

  void _onPageChange(int value) {
    setState(() {
      currentPage = value;
    });
  }

  Widget _buildTabItem({String title, int position}) {
    Size size = MediaQuery.of(context).size;
    return Flexible(
      child: GestureDetector(
        onTap: () {
          _pageController.jumpToPage(position);
        },
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: size.width * 0.04,
              ),
              Text(
                title,
                style: TextStyle(
                  color: (position == currentPage) ? pink : grey,
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: size.width * 0.04,
              ),
              Container(
                height: size.width * 0.005,
                color: (position == currentPage) ? pink : lightGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
