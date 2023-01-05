//著作ok

import 'package:Keioboys/MessageTab/Message.dart';
import 'package:equatable/equatable.dart';

abstract class MessageEvent extends Equatable {
  MessageEvent([List props = const []]) : super();
}

class SendReportEvent extends MessageEvent {
  final Message report;
  final String reason;

  SendReportEvent({
    this.report,
    this.reason,
  });
  @override
  List<Object> get props => [
        report,
        reason,
      ];
}

//class InquiryEvent extends MessagingEvent {
//  final Message message;
//
//  SendMessageEvent({
//    this.message,
//  });
//  @override
//  List<Object> get props => [message];
//}

class MessageStreamEvent extends MessageEvent {
  final String currentUserId, selectedUserId;
//  final Timestamp lastMessageTimeStamp;

//  MessageStreamEvent(
//      {this.currentUserId, this.selectedUserId, this.lastMessageTimeStamp});
  MessageStreamEvent({this.currentUserId, this.selectedUserId});

  @override
//  List<Object> get props =>
//      [currentUserId, selectedUserId, lastMessageTimeStamp];
  List<Object> get props => [currentUserId, selectedUserId];
}

class NotificationStreamEvent extends MessageEvent {
  NotificationStreamEvent();

  @override
  List<Object> get props => [];
}
