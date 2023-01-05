import 'package:Keioboys/FB/MessageFB.dart';
import 'package:Keioboys/MessageTab/Message.dart';
import 'package:Keioboys/MessageTab/MessageBloc/MessageBloc.dart';
import 'package:Keioboys/MessageTab/MessageBloc/MessageEvent.dart';
import 'package:Keioboys/consts.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef ReportOthersCallback = void Function(bool reportOthers);

class ReportOthersDialog extends StatefulWidget {
  final String currentUserId;
  final String selectedUserId;
  final ReportOthersCallback reportOthersCallback;

  const ReportOthersDialog({
    this.currentUserId,
    this.selectedUserId,
    this.reportOthersCallback,
  });
  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportOthersDialog> {
  MessageFB _messageFB = MessageFB();
  MessageBloc _messageBloc;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _messageBloc = MessageBloc(messageFB: _messageFB);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AlertDialog(
          title: Text('ユーザーを報告'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: size.width * 0.9,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: size.width * 0.02,
                  ),
                  TextFormField(
                    controller: _textController,
                    cursorColor: pink,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: black87,
                          width: size.width * 0.002,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: black87,
                          width: size.width * 0.002,
                        ),
                      ),
                      labelText: '報告の理由',
                      labelStyle: TextStyle(
                        color: black87,
                      ),
                    ),
                    autofocus: true,
                    minLines: 3,
                    maxLines: null,
                    maxLengthEnforcement: MaxLengthEnforcement.none,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              splashColor: lightGrey,
              child: Text(
                "キャンセル",
                style: TextStyle(
                  color: black87,
                ),
              ),
              onPressed: () {
                widget.reportOthersCallback(false);
              },
            ),
            FlatButton(
              splashColor: lightGrey,
              child: Text(
                "送信",
                style: TextStyle(color: pink),
              ),
              onPressed: () {
                _messageBloc.add(
                  SendReportEvent(
                      report: Message(
                        text: _textController.text,
                        currentUserId: widget.currentUserId,
                        selectedUserId: widget.selectedUserId,
                      ),
                      reason: 'others'),
                );
                _textController.clear();
                widget.reportOthersCallback(false);
                Flushbar(
                  message: "ユーザーを報告しました。",
                  backgroundColor: pink,
                  duration: Duration(seconds: 3),
                )..show(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
