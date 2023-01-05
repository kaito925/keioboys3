//著作権ok

import 'package:Keioboys/Search/SearchNewBloc/SearchNewEvent.dart';
import 'package:Keioboys/Search/SearchNewBloc/SearchNewState.dart';
import 'package:bloc/bloc.dart';
import 'package:Keioboys/FB/SearchNewFB.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class SearchNewBloc extends Bloc<SearchNewEvent, SearchNewState> {
  SearchNewFB _searchNewFB;

  SearchNewBloc({@required SearchNewFB searchNewFB})
      : assert(searchNewFB != null),
        _searchNewFB = searchNewFB,
        super(LoadingState());

  @override
  Stream<SearchNewState> mapEventToState(SearchNewEvent event) async* {
    if (event is GetUserEvent) {
      yield* _mapGetUserToState(
        interestedGender: event.interestedGender,
      );
    }
  }

  Stream<SearchNewState> _mapGetUserToState({String interestedGender}) async* {
    yield LoadingState();
    Stream<QuerySnapshot> userListSnapshot =
        _searchNewFB.getUserList(interestedGender);
    yield LoadUserListState(
      userList: userListSnapshot,
    );
  }
}
