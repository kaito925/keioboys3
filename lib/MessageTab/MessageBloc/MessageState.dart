//著作ok

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class MessageState extends Equatable {
  MessageState([List props = const []]) : super();
}

class MessageInitialState extends MessageState {
  @override
  List<Object> get props => [];
}

class MessageLoadingState extends MessageState {
  @override
  List<Object> get props => [];
}

class MessageLoadedState extends MessageState {
  final Stream<QuerySnapshot> messageStream;

  MessageLoadedState({this.messageStream});

  @override
  List<Object> get props => [messageStream];
}

class NotificationLoadingState extends MessageState {
  @override
  List<Object> get props => [];
}

class NotificationLoadedState extends MessageState {
  final Stream<QuerySnapshot> notificationStream;

  NotificationLoadedState({this.notificationStream});

  @override
  List<Object> get props => [notificationStream];
}
