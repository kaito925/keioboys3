//著作ok
import 'package:equatable/equatable.dart';

abstract class MatchEvent extends Equatable {
  MatchEvent([List props = const []]) : super();
}

class LoadMatchUserEvent extends MatchEvent {
  final String currentUserId;

  LoadMatchUserEvent({this.currentUserId});

  @override
  List<Object> get props => [currentUserId];
}

class GetUserEvent extends MatchEvent {
  final String currentUserId;

  GetUserEvent({this.currentUserId});

  @override
  List<Object> get props => [currentUserId];
}

class LoadLikedUserEvent extends MatchEvent {
  final String currentUserId;

  LoadLikedUserEvent({this.currentUserId});

  @override
  List<Object> get props => [currentUserId];
}

class AcceptLikedUserEvent extends MatchEvent {
  final String currentUser, likedUser, likedUserDecision;

  AcceptLikedUserEvent({
    this.currentUser,
    this.likedUser,
    this.likedUserDecision,
  });

  @override
  List<Object> get props => [currentUser, likedUser, likedUserDecision];
}

class DeleteUserEvent extends MatchEvent {
  final String currentUser, likedUser;

  DeleteUserEvent({this.currentUser, this.likedUser});

  @override
  List<Object> get props => [currentUser, likedUser];
}

//class GoMessageEvent extends MatchEvent {
//  final String currentUser, matchUser;
//
//  GoMessageEvent({this.currentUser, this.matchUser});
//
//  @override
//  List<Object> get props => [currentUser, matchUser];
//}
