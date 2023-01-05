//import 'package:Keioboys/Auth/UserData.dart';
//import 'package:equatable/equatable.dart';
//
//abstract class SearchEvent extends Equatable {
//  SearchEvent([List props = const []]) : super();
//}

//class LoadUserEvent extends SearchEvent {
//  final String userId;
//
//  LoadUserEvent({this.userId});
//  @override
//  List<Object> get props => [userId];
//}

//class LoadCurrentUserEvent extends SearchEvent {
//  final String userId;
//
//  LoadCurrentUserEvent({this.userId});
//  @override
//  List<Object> get props => [userId];
//}

//class LikeEvent extends SearchEvent {
//  final String selectedUserId;
////  final String currentUserId, selectedUserId, name, photo;
//  final User currentUser;
////  final int differenceBack;
//
//  LikeEvent({
//    this.selectedUserId,
//    this.currentUser,
////      this.differenceBack
//  });

//  LikeEvent(
//      {this.currentUserId,
//      this.selectedUserId,
//      this.name,
//      this.photo,
//      this.currentUser,
//      this.differenceBack});

//  @override
//  List<Object> get props => [selectedUserId, currentUser];
//      [currentUser.uid, selectedUserId, currentUser.name, currentUser.photo];
//      [currentUserId, selectedUserId, name, photo, differenceBack];
//}

//class SuperLikeEvent extends SearchEvent {
//  final String selectedUserId;
//  final User currentUser;
//
//  SuperLikeEvent({
//    this.selectedUserId,
//    this.currentUser,
//  });
//
//  @override
//  List<Object> get props => [selectedUserId, currentUser];
//}

//class NopeEvent extends SearchEvent {
//  final String currentUserId, selectedUserId;
////  final User currentUser;
//
//  NopeEvent({this.currentUserId, this.selectedUserId});
////  NopeEvent(this.currentUserId, this.selectedUserId, this.currentUser);
//
//  @override
//  List<Object> get props => [currentUserId, selectedUserId];
//}
