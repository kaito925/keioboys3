////TODO 基本ネイティブアプリと場合分けして、ネイティブのほうはいじらない
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:Keioboys/Auth/AuthBloc/Bloc.dart';
import 'package:Keioboys/Auth/MaintenanceNowPage.dart';
import 'package:Keioboys/Auth/RequireUpdatePage.dart';
import 'package:Keioboys/Auth/NewNotificationPage.dart';
import 'package:Keioboys/Widgets/BlockDelegate.dart';
import 'package:Keioboys/Auth/Login/LoginPage.dart';
import 'package:Keioboys/Auth/EmailPage.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:Keioboys/consts.dart';
import 'Auth/SplashPage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:seo_renderer/seo_renderer.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions firebaseConfig = FirebaseOptions(
    apiKey: "AIzaSyDGHRocEMdaLLWx3Jip2GpQQSgQGnkzwQI",
    authDomain: "stars-jp-stars.firebaseapp.com",
    databaseURL: "https://stars-jp-stars.firebaseio.com",
    projectId: "stars-jp-stars",
    storageBucket: "stars-jp-stars.appspot.com",
    messagingSenderId: "487843436120",
    appId: "1:487843436120:web:6efd70d7f09d9b862d1c2d",
    // measurementId: "G-CCPGM02828",
  );

  await Firebase.initializeApp(
    // name: "stars-jp-stars",
    options: (web) ? firebaseConfig : null,
  );

  if (android || ios) {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
  if (android || ios) {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
  }
  if (ios) {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  Bloc.observer = MyBlocObserver();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: white,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  if (android || ios) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runZonedGuarded(() async {
        runApp(
          MyApp(),
        );
      }, (e, s) async => await FirebaseCrashlytics.instance.recordError(e, s));
    });
  } else {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(
        MyApp(),
      );
    });
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserFB _userFB = UserFB();
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  AuthBloc _authBloc;
//  String matchPhoto = '';
//  String matchName = '';

  @override
  void initState() {
    _authBloc = AuthBloc(userFB: _userFB);
    _authBloc.add(AppStart());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _authBloc,
      child: MaterialApp(
        title: "Keioboys - 学生向けマッチングアプリ - 恋人/友達作りをしよう！男性は早稲田・慶應限定",
        localizationsDelegates: [
//          JapaneseCupertinoLocalizations.delegate,
//          GlobalMaterialLocalizations.delegate,
//          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ja', 'JP'),
        ],
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
        theme: kThemeData,
        builder: (context, child) => ResponsiveWrapper.builder(child,
            maxWidth: 480,
            minWidth: 480,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ],
            background: Container(color: Color(0xFFF5F5F5))),
        home: BlocBuilder(
          bloc: _authBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is Initial) {
              return SplashPage();
            } else if (state is RequireUpdate) {
              return RequireUpdatePage();
            } else if (state is MaintenanceNow) {
              return MaintenanceNowPage(maintenanceText: state.maintenanceText);
            }
//            else if (state is NewNotification) {
//              return NewNotificationPage(currentUser: state.currentUser);
//            }
            else if (state is Authenticated) {
              print('Authenticated');
              _userFB.updateInfo(
                currentUser: state.currentUser,
                context: context,
              );
//              });
//              return HomeTab(
//                userFB: _userFB,
//                currentUser: state.currentUser,
//                fromMain: true,
//              );
              return NewNotificationPage(
                currentUser: state.currentUser,
              );
            } else if (state is NotVerified) {
              return EmailPage(
                userFB: _userFB,
                gender: state.gender,
                fromMain: true,
              );
            }
//            if (state is AuthButNotSet) {
//              print(state.userId);
//              print(_userRepo);
//              return ProfilePage(
//                userRepo: _userRepo,
//              );
//            }
            else if (state is Unauthenticated) {
              print('Unauthenticated');
              return LoginPage(
                userFB: _userFB,
                fromMain: true,
              );
            } else {
              return Container();
            }
          },
        ),
      ),
//      ),
    );
  }
}
