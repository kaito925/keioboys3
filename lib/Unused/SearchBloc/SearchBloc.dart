//import 'package:Keioboys/Auth/UserData.dart';
//import 'package:Keioboys/FB/SearchFB.dart';
//
//import 'dart:async';
//import 'Bloc.dart';
//import 'package:bloc/bloc.dart';
//import 'package:meta/meta.dart';
//
//class SearchBloc extends Bloc<SearchEvent, SearchState> {
//  SearchFB _searchFB;
//  SearchBloc({
//    @required SearchFB searchFB,
//  })  : assert(
//          searchFB != null,
//        ),
//        _searchFB = searchFB;
//
//  @override
//  SearchState get initialState => InitialState();
//
//  @override
//  Stream<SearchState> mapEventToState(SearchEvent event) async* {
//    if (event is LikeEvent) {
////      print('event.differenceBack ${event.differenceBack}');
//      yield* _mapLikeToState(
////        currentUserId: event.currentUser.uid,
//        selectedUserId: event.selectedUserId,
////        name: event.currentUser.name,
////        photo: event.currentUser.photo,
//        currentUser: event.currentUser,
//      );
//    }
//    if (event is SuperLikeEvent) {
//      yield* _mapSuperLikeToState(
//        selectedUserId: event.selectedUserId,
//        currentUser: event.currentUser,
//      );
//    }
//    if (event is NopeEvent) {
//      yield* _mapNopeToState(
//        currentUserId: event.currentUserId,
//        selectedUserId: event.selectedUserId,
////          currentUser: event.currentUser
//      );
//    }
//    if (event is LoadUserEvent) {
//      yield* _mapLoadUserToState(currentUserId: event.userId);
//    }
//    if (event is LoadCurrentUserEvent) {
//      yield* _mapLoadCurrentUserToState(currentUserId: event.userId);
//    }
//  }

//  Stream<SearchState> _mapLoadUserToState({String currentUserId}) async* {
//    print('_mapLoadUserToState');
////    yield LoadingState();
////    var currentUserBasic = await _searchRepo.getCurrentUserBasic(currentUserId);
//    yield LoadUserState(); //currentUserBasic);
//  }

//  Stream<SearchState> _mapLoadCurrentUserToState({String currentUserId}) async* {
//    yield LoadingState();
//    User currentUser = await _searchRepo.getUserInterests(currentUserId);
//    yield LoadCurrentUserState(currentUser);
//  }

//  Stream<SearchState> _mapLikeToState({
//    String currentUserId,
//    String selectedUserId,
////    String name,
////    String photo,
//    User currentUser,
//  }) async* {
//    print('_mapLikeToState');
////    yield LoadingState();
//    //yield LoadUserState();
////    yield LoadUserState(currentUser);
//    _searchFB.like(
//      currentUser.uid,
//      selectedUserId,
//      currentUser.name,
//      currentUser.birthday,
//      currentUser.photo,
//      likeCount,
//    );
//  }
//    _searchRepo.likeUser(currentUserId, selectedUserId, name, photo);
//    User currentUser = await _searchRepo
//        .getCurrentUserBasic(
//            currentUserId);

//    yield LoadUserState(currentUser);

//    yield LoadUserState(user, currentUser);

//  Stream<SearchState> _mapSuperLikeToState({
//    String currentUserId,
//    String selectedUserId,
//    User currentUser,
//  }) async* {
//    _searchFB.superLike(
//      currentUser.uid,
//      selectedUserId,
//      currentUser.name,
//      currentUser.birthday,
//      currentUser.photo,
//      superLikeCount,
//    );
//  }

//  Stream<SearchState> _mapNopeToState(
//      {String currentUserId, String selectedUserId}) async* {
//      {String currentUserId, String selectedUserId, User currentUser}) async* {
//yield LoadUserState();
//    yield LoadingState();
//    _searchFB.nope(currentUserId, selectedUserId);
//    User user = await _searchRepo.passUser(currentUserId, selectedUserId);
//User currentUser = await _searchRepo.getCurrentUserBasic(currentUserId);
//    yield LoadUserState();
//    yield LoadUserState(currentUser);
//    yield LoadUserState(user, currentUser);
//  }

//  Future<List> getUserList2({String currentUserId}) async {
//    List userList = await _searchRepo.getUserList(currentUserId);
//    for (var user in userList) {
//      print('uidList: ${user.uid}');
//    }
//    return userList;
//  }
//}
