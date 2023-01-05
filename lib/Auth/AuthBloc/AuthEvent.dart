//著作ok

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:Keioboys/Widgets/UserData.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super();
}

class AppStart extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class SignUp extends AuthenticationEvent {
  final String gender;
  SignUp({this.gender}) : super([gender]);
  @override
  List<Object> get props => [gender];
}

class LogIn extends AuthenticationEvent {
  final UserData currentUser;
  LogIn({this.currentUser});
  @override
  List<Object> get props => [currentUser];
}

class LogOut extends AuthenticationEvent {
  final String currentUserId;
  LogOut({this.currentUserId}) : super([currentUserId]);
  @override
  List<Object> get props => [currentUserId];
}

//class UpdateEmailVerified extends AuthenticationEvent {
//  @override
//  List<Object> get props => [];
//}

class EmailVerified extends AuthenticationEvent {
  final UserData currentUser;
  EmailVerified({this.currentUser}) : super([currentUser]);
  @override
  List<Object> get props => [currentUser];
}

//class EmailNotVerified extends AuthenticationEvent {
//  @override
//  List<Object> get props => [];
//}

class Deleted extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class NotificationChecked extends AuthenticationEvent {
  final UserData currentUser;
  NotificationChecked({this.currentUser}) : super([currentUser]);
  @override
  List<Object> get props => [currentUser];
}
