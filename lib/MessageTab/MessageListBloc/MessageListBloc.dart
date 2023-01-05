//著作ok
import 'package:bloc/bloc.dart';
import 'package:Keioboys/MessageTab/MessageListBloc/Bloc.dart';
import 'package:Keioboys/FB/MessageListFB.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class MessageListBloc extends Bloc<MessageListEvent, MessageListState> {
  MessageListFB _messageListFB;

  MessageListBloc({@required MessageListFB messageListRepo})
      : assert(messageListRepo != null),
        _messageListFB = messageListRepo,
        super(MessageInitialState());

  @override
  Stream<MessageListState> mapEventToState(MessageListEvent event) async* {
    if (event is GetMessageListEvent) {
      yield* _mapGetMessageListToState(currentUserId: event.currentUserId);
    }
  }

  Stream<MessageListState> _mapGetMessageListToState({currentUserId}) async* {
    yield LoadingState();
    Stream<QuerySnapshot> messageListStream =
        _messageListFB.getMessageList(currentUserId: currentUserId);
    yield LoadState(messageListStream: messageListStream);
  }
}
