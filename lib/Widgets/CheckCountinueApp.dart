import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:Keioboys/Auth/AuthBloc/AuthBloc.dart';
import 'package:Keioboys/Auth/AuthBloc/AuthEvent.dart';
import 'package:Keioboys/Auth/MaintenanceNowPage.dart';
import 'package:Keioboys/Auth/RequireUpdatePage.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:Keioboys/Widgets/SlideRoute.dart';

checkContinueApp(context) {
  final UserFB _userFB = UserFB();
  AuthBloc _authBloc;
  _authBloc = AuthBloc(userFB: _userFB);
  Timer.periodic(
    Duration(minutes: 10),
    (Timer t) async {
      print('checkContinueUsingApp');
      List maintenanceList = await _userFB.checkMaintenance();
      int minimumBuildNumber = await _userFB.checkMinimumBuildNumber();
      final PackageInfo info = await PackageInfo.fromPlatform();
      int currentBuildNumber = int.parse(info.buildNumber);
      if (minimumBuildNumber > currentBuildNumber) {
        _authBloc.add(AppStart());
        Navigator.of(context).pushReplacement(
          slideRoute(
            RequireUpdatePage(),
          ),
        );
      } else if (maintenanceList[0] == true) {
        _authBloc.add(AppStart());
        Navigator.of(context).pushReplacement(
          slideRoute(
            MaintenanceNowPage(),
          ),
        );
      }
    },
  );
}
