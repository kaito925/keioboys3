//著作ok
import 'package:equatable/equatable.dart';

abstract class MessageListEvent extends Equatable {
  MessageListEvent([List props = const []]) : super();
}

class GetMessageListEvent extends MessageListEvent {
  final String currentUserId;

  GetMessageListEvent({this.currentUserId});

  @override
  List<Object> get props => [currentUserId];
}
