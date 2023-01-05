import 'package:bloc/bloc.dart';
import 'package:Keioboys/MessageTab/MessageBloc/MessageEvent.dart';
import 'package:Keioboys/MessageTab/MessageBloc/MessageState.dart';
import 'package:Keioboys/FB/MessageFB.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageFB _messageFB;

  MessageBloc({MessageFB messageFB})
      : assert(messageFB != null),
        _messageFB = messageFB,
        super(MessageInitialState()); //ここにinitialになってた

//  MessageState get initialState => MessageInitialState();

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is MessageStreamEvent) {
      yield* _mapMessageStreamToState(
        currentUserId: event.currentUserId,
        selectedUserId: event.selectedUserId,
//          lastMessageTimeStamp: event.lastMessageTimeStamp
      );
    }

    if (event is NotificationStreamEvent) {
      yield* _mapNotificationStreamToState();
    }

    if (event is SendReportEvent) {
      yield* _mapSendReportToState(
        report: event.report,
        reason: event.reason,
      );
    }
  }

//  Stream<MessagingState> _mapStreamToState(
//      {currentId, selectedId, lastMessageTimeStamp}) async* {
  Stream<MessageState> _mapMessageStreamToState(
      {currentUserId, selectedUserId}) async* {
    yield MessageLoadingState();
    Stream<QuerySnapshot> messageStream = _messageFB.getMessage(
      currentUserId: currentUserId,
      selectedUserId: selectedUserId,
    );
    yield MessageLoadedState(messageStream: messageStream);
  }

  Stream<MessageState> _mapNotificationStreamToState() async* {
    yield NotificationLoadingState();
    Stream<QuerySnapshot> notificationStream = _messageFB.getNotification();
    yield NotificationLoadedState(notificationStream: notificationStream);
  }

  Stream<MessageState> _mapSendReportToState({
    report,
    reason,
  }) async* {
    await _messageFB.sendReport(
      report: report,
      reason: reason,
    );
  }
}
