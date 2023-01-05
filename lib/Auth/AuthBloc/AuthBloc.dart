//著作ok
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:Keioboys/Auth/AuthBloc/AuthEvent.dart';
import 'package:Keioboys/Auth/AuthBloc/AuthState.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:Keioboys/Widgets/UserData.dart';

class AuthBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserFB _userFB;
  UserData _currentUser;
  List maintenanceList;
  bool newNotification;
  int minimumBuildNumber;
  int currentBuildNumber;

  AuthBloc({@required UserFB userFB})
      : assert(userFB != null),
        _userFB = userFB,
        super(Initial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStart) {
      yield* _mapAppStartToState();
    } else if (event is SignUp) {
      yield* _mapSignUpToState(gender: event.gender);
    } else if (event is LogIn) {
//    } else if (event is LogIn || event is UpdateEmailVerified) {
      yield* _mapLogInToState(currentUser: event.currentUser);
    } else if (event is EmailVerified) {
      yield* _mapEmailVerifiedToState(
        currentUser: event.currentUser,
      );
//    } else if (event is EmailNotVerified) {
//      yield* _mapEmailNotVerifiedToState();
    } else if (event is LogOut) {
      yield* _mapLogOutToState(
        currentUserId: event.currentUserId,
      );
    } else if (event is Deleted) {
      yield* _mapDeletedToState();
    } else if (event is NotificationChecked) {
      yield* _mapNotificationCheckedToState(currentUser: event.currentUser);
    }
  }

  Stream<AuthenticationState> _mapAppStartToState() async* {
    try {
      minimumBuildNumber = await _userFB.checkMinimumBuildNumber();
      final PackageInfo info = await PackageInfo.fromPlatform();
      currentBuildNumber = int.parse(info.buildNumber);
      if (minimumBuildNumber > currentBuildNumber) {
        yield RequireUpdate();
      } else {
        maintenanceList = await _userFB.checkMaintenance();
        print('maintenance: ${maintenanceList[0]}');
        if (maintenanceList[0] == true) {
          yield MaintenanceNow(maintenanceText: maintenanceList[1]);
        } else {
          final isSignedIn = await _userFB.isSignedIn();
          print('isSignedIn: $isSignedIn');
          if (isSignedIn) {
            final uid = await _userFB.getCurrentUserId();
            _currentUser = await _userFB.getCurrentUser(uid);
            final isVerified = await _userFB.isEmailVerified();
            print('isVerified: $isVerified');
            if (isVerified) {
              print('currentUserId: ${_currentUser.uid}');
//              newNotification = await _userFB.checkNewNotification(
//                  lastCheckedNotificationTime:
//                      _currentUser.lastCheckedNotificationTime);
//              print('newNotification: $newNotification');
//              if (newNotification == true) {
//                yield NewNotification(currentUser: _currentUser);
//              } else {
              yield Authenticated(currentUser: _currentUser);
//              }
            } else {
              yield NotVerified(gender: _currentUser.gender);
            }
          } else {
            yield Unauthenticated();
          }
        }
      }
    } catch (error) {
      print('error: $error');
//      yield Authenticated(currentUser: _currentUser);
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapSignUpToState({gender}) async* {
    yield NotVerified(gender: gender);
  }

  Stream<AuthenticationState> _mapLogInToState({currentUser}) async* {
    final isVerified = await _userFB.isEmailVerified();
    print('isVerified: $isVerified');
    if (isVerified) {
      print('currentUser in AuthBloc: ${_currentUser.name}');
      yield Authenticated(currentUser: currentUser);
    } else {
      print('AuthState: NotVerified');
      yield NotVerified(gender: _currentUser.gender);
    }
  }

  Stream<AuthenticationState> _mapEmailVerifiedToState({currentUser}) async* {
//    final uid = await _userFB.getCurrentUserId();
//    _currentUser = await _userFB.getCurrentUser(uid);
    yield Authenticated(currentUser: currentUser);
  }

  Stream<AuthenticationState> _mapNotificationCheckedToState(
      {currentUser}) async* {
    yield Authenticated(currentUser: currentUser);
  }

//  Stream<AuthenticationState> _mapEmailNotVerifiedToState() async* {
//    final uid = await _userFB.getCurrentUserId();
//    yield NotVerified(userId: uid);
//  }

  Stream<AuthenticationState> _mapLogOutToState({currentUserId}) async* {
    yield Unauthenticated();
    _userFB.signOut(currentUserId: currentUserId);
  }

  Stream<AuthenticationState> _mapDeletedToState() async* {
    yield Unauthenticated();
  }
}
