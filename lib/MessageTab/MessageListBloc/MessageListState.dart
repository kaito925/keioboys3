//著作ok
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class MessageListState extends Equatable {
  MessageListState([List props = const []]) : super();
}

class MessageInitialState extends MessageListState {
  @override
  List<Object> get props => [];
}

class LoadingState extends MessageListState {
  @override
  List<Object> get props => [];
}

class LoadState extends MessageListState {
  final Stream<QuerySnapshot> messageListStream;

  LoadState({this.messageListStream});

  @override
  List<Object> get props => [messageListStream];
}
