//著作権ok

import 'package:Keioboys/MessageTab/MatchBloc/MatchEvent.dart';
import 'package:Keioboys/MessageTab/MatchBloc/MatchState.dart';

import 'package:bloc/bloc.dart';
import 'package:Keioboys/FB/MatchFB.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class MatchBloc extends Bloc<MatchEvent, LikedAndMatchState> {
  MatchFB _matchFB;

  MatchBloc({@required MatchFB matchFB})
      : assert(matchFB != null),
        _matchFB = matchFB,
        super(LoadingState());

  @override
  Stream<LikedAndMatchState> mapEventToState(MatchEvent event) async* {
    if (event is GetUserEvent) {
      yield* _mapLoadAgeVerificationToState(currentUserId: event.currentUserId);
    } else if (event is LoadLikedUserEvent) {
      yield* _mapLoadLikedUserToState(currentUserId: event.currentUserId);
    } else if (event is LoadMatchUserEvent) {
      yield* _mapLoadMatchUserToState(currentUserId: event.currentUserId);
    } else if (event is DeleteUserEvent) {
      yield* _mapDeleteLikedUserState(
          currentUserId: event.currentUser, likedUserId: event.likedUser);
    }
//    if (event is GoMessageEvent) {
//      yield* _mapGoMessageState(
//          currentUserId: event.currentUser, matchUserId: event.matchUser);
//    }
  }

  Stream<LikedAndMatchState> _mapLoadAgeVerificationToState(
      {String currentUserId}) async* {
    yield LoadingState();
    Stream<DocumentSnapshot> ageVerificationSnapshot =
        _matchFB.getAgeVerification(currentUserId);
    yield LoadAgeVerificationState(
      ageVerificationSnapshot: ageVerificationSnapshot,
    );
  }

  Stream<LikedAndMatchState> _mapLoadLikedUserToState(
      {String currentUserId}) async* {
    yield LoadingState();
    Stream<QuerySnapshot> likedList = _matchFB.getLikedList(currentUserId);
    Stream<QuerySnapshot> superLikedList =
        _matchFB.getSuperLikedList(currentUserId);
    yield LoadLikedListState(
      likedList: likedList,
      superLikedList: superLikedList,
    );
  }

  Stream<LikedAndMatchState> _mapLoadMatchUserToState(
      {String currentUserId}) async* {
    yield LoadingState();
    Stream<QuerySnapshot> matchUser = _matchFB.getMatchList(currentUserId);
    yield LoadMatchUserState(matchList: matchUser);
  }

  Stream<LikedAndMatchState> _mapDeleteLikedUserState(
      {currentUserId, likedUserId}) async* {
    _matchFB.deleteLikedUser(
      currentUserId,
      likedUserId,
    );
  }

//  Stream<MatchState> _mapGoMessageState({currentUserId, matchUserId}) async* {
//    _matchFB.goMessage(currentUserId: currentUserId, thisUserId: matchUserId);
//  }
}
