//著作ok

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:Keioboys/Widgets/UserData.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super();
}

class Initial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class RequireUpdate extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class MaintenanceNow extends AuthenticationState {
  final String maintenanceText;
  MaintenanceNow({this.maintenanceText}) : super([maintenanceText]);
  @override
  List<Object> get props => [];
}

class NewNotification extends AuthenticationState {
  final UserData currentUser;
  NewNotification({this.currentUser}) : super([currentUser]);
  @override
  List<Object> get props => [currentUser];
}

class Authenticated extends AuthenticationState {
  final UserData currentUser;

  Authenticated({this.currentUser}) : super([currentUser]);

  @override
  List<Object> get props => [currentUser];
}

class Unauthenticated extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class NotVerified extends AuthenticationState {
  final String gender;

  NotVerified({this.gender}) : super([gender]);

  @override
  List<Object> get props => [gender];
}
