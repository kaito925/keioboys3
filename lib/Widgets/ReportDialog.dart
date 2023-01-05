import 'package:Keioboys/FB/MessageFB.dart';
import 'package:Keioboys/MessageTab/Message.dart';
import 'package:Keioboys/MessageTab/MessageBloc/MessageBloc.dart';
import 'package:Keioboys/MessageTab/MessageBloc/MessageEvent.dart';
import 'package:Keioboys/consts.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef ReportCallback = void Function(bool report);
typedef ReportOthersCallback = void Function(bool reportOthrs);

class ReportDialog extends StatefulWidget {
  final String currentUserId;
  final String selectedUserId;
  final ReportCallback reportCallback;
  final ReportOthersCallback reportOthersCallback;

  const ReportDialog({
    this.currentUserId,
    this.selectedUserId,
    this.reportCallback,
    this.reportOthersCallback,
  });
  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  MessageFB _messageFB = MessageFB();
  MessageBloc _messageBloc;

  @override
  void initState() {
    _messageBloc = MessageBloc(messageFB: _messageFB);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {},
      child: Container(
//        padding: EdgeInsets.only(
//          top: size.height * 0.1,
//          left: size.height * 0.1,
//          right: size.height * 0.1,
//          bottom: size.height * 0.1,
//        ),
        child: AlertDialog(
          title: Text('ユーザーを報告'),
          content: Container(
            width: size.width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
//                                                  crossAxisAlignment:
//                                                      CrossAxisAlignment.start,
              children: <Widget>[
//                SizedBox(
//                  height: size.height * 0.01,
//                ),
                Divider(
                  color: black87,
                ),
                Container(
                  height: size.height * 0.06,
                  child: FlatButton(
                    child: Center(
                      child: Text(
                        '不適切な写真',
                        style: TextStyle(
                          color: black87,
                          fontSize: size.width * 0.05,
                        ),
                      ),
                    ),
                    onPressed: () {
                      _messageBloc.add(
                        SendReportEvent(
                            report: Message(
                              currentUserId: widget.currentUserId,
                              selectedUserId: widget.selectedUserId,
                            ),
                            reason: 'photo'),
                      );
                      widget.reportCallback(false);
                      Flushbar(
                        message: "ユーザーを報告しました。",
                        backgroundColor: pink,
                        duration: Duration(seconds: 3),
                      )..show(context);
                    },
                  ),
                ),
                Divider(
                  color: black87,
                ),
                Container(
                  height: size.height * 0.06,
                  child: FlatButton(
                    child: Container(
                      height: size.height * 0.04,
                      width: size.width * 0.9,
                      child: Center(
                        child: Text(
                          '不適切な自己紹介',
                          style: TextStyle(
                            color: black87,
                            fontSize: size.width * 0.05,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _messageBloc.add(
                        SendReportEvent(
                            report: Message(
                              currentUserId: widget.currentUserId,
                              selectedUserId: widget.selectedUserId,
                            ),
                            reason: 'bio'),
                      );
                      widget.reportCallback(false);
                      Flushbar(
                        message: "ユーザーを報告しました。",
                        backgroundColor: pink,
                        duration: Duration(seconds: 3),
                      )..show(context);
                    },
                  ),
                ),
                Divider(
                  color: black87,
                ),
                Container(
                  height: size.height * 0.06,
                  child: FlatButton(
                    child: Container(
                      height: size.height * 0.04,
                      width: size.width * 0.9,
                      child: Center(
                        child: Text(
                          '不適切なメッセージ',
                          style: TextStyle(
                            color: black87,
                            fontSize: size.width * 0.05,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _messageBloc.add(
                        SendReportEvent(
                            report: Message(
                              currentUserId: widget.currentUserId,
                              selectedUserId: widget.selectedUserId,
                            ),
                            reason: 'message'),
                      );
                      widget.reportCallback(false);
                      Flushbar(
                        message: "ユーザーを報告しました。",
                        backgroundColor: pink,
                        duration: Duration(seconds: 3),
                      )..show(context);
                    },
                  ),
                ),
                Divider(
                  color: black87,
                ),
                Container(
                  height: size.height * 0.06,
                  child: FlatButton(
                    child: Center(
                      child: Text(
                        'その他の理由',
                        style: TextStyle(
                          color: black87,
                          fontSize: size.width * 0.05,
                        ),
                      ),
                    ),
                    onPressed: () {
                      widget.reportOthersCallback(true);
                    },
                  ),
                ),
                Divider(
                  color: black87,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: FlatButton(
                    child: Text(
                      "キャンセル",
                      style: TextStyle(
                        color: black87,
                        fontSize: size.width * 0.05,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    onPressed: () {
                      widget.reportCallback(false);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
