//著作　ok

//import 'package:chewie/chewie.dart';
import 'package:Keioboys/Auth/AuthBloc/AuthBloc.dart';
import 'package:Keioboys/Auth/AuthBloc/AuthEvent.dart';
import 'package:Keioboys/Auth/EmailPage.dart';
import 'package:Keioboys/Auth/NewNotificationPage.dart';
import 'package:Keioboys/Auth/SignUp/SignUp1.dart';
import 'package:Keioboys/Auth/Login/PasswordResetPage.dart';
import 'package:Keioboys/FB/UserFB.dart';
import 'package:Keioboys/SettingTab/HowToUsePage.dart';
import 'package:Keioboys/Widgets/SlideRoute.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:Keioboys/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:Keioboys/consts.dart';
// import 'package:seo_renderer/seo_renderer.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LoginPage extends StatefulWidget {
  final UserFB _userFB;
  final bool _fromMain;

  LoginPage({
    Key key,
    @required UserFB userFB,
    bool fromMain,
  })  : assert(userFB != null),
        _userFB = userFB,
        _fromMain = fromMain,
        super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserFB get _userFB => widget._userFB;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
//  YoutubePlayerController _controller = YoutubePlayerController(
//    initialVideoId: '5bvqKL0o0sc',
//    params: YoutubePlayerParams(
//      startAt: Duration(seconds: 0),
//      showControls: true,
//      autoPlay: false,
//      showFullscreenButton: true,
//    ),
//  );
  bool _showPassword;
  bool _loading;

  @override
  void initState() {
    _showPassword = false;
    _loading = false;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
//    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print("${size.width}");
    print("${size.height}");
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                color: white,
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
//                        YoutubePlayerIFrame(
//                          controller: _controller,
//                          aspectRatio: 16 / 9,
//                        ),

//                        SizedBox(
//                          height: size.height * 0.03,
//                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              slideRoute(
                                HowToUsePage(),
                              ),
                            );
                          },
                          child: Container(
                            width: size.width * 1,
                            height: size.height * 0.12,
                            decoration: BoxDecoration(
                              color: pink,
//                              borderRadius: BorderRadius.circular(
//                                100,
//                              ),
                              border: Border.all(
                                color: pink,
                                width: size.width * 0.0025,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: size.width * 0.07,
                                            color: white,
                                          ),
                                          children: [
                                            WidgetSpan(
                                              child: Image.asset(
                                                'assets/images/beginner.png',
                                                width: size.width * 0.12,
                                                height: size.height * 0.06,
                                              ),
                                            ),
                                            TextSpan(text: 'Keioboysとは?'),
                                            WidgetSpan(
                                              child: SizedBox(
                                                width: size.width * 0.05,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.width * 0.01,
                                      ),
                                      Container(
                                        color: white,
                                        height: size.width * 0.005,
                                        width: size.width * 0.65,
                                      )
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      0,
                                      0,
                                      size.width * 0.025,
                                      0,
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: size.height * 0.027,
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: white,
                                          size: size.width * 0.08,
                                        ),
                                        SizedBox(
                                          height: size.width * 0.01,
                                        ),
                                        Text(
                                          'コチラ',
                                          style: TextStyle(
                                            fontSize: size.width * 0.03,
                                            fontWeight: FontWeight.bold,
                                            color: white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.07,
                        ),
                        Center(
                          child: Text(
                            "Keioboys",
                            style: TextStyle(
                              fontFamily: 'DancingScript',
                              fontSize: size.width * 0.2,
                              color: pink,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.06,
                        ),
//                        SizedBox(
//                          height: size.height * 0.08,
//                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: size.width * 0.04,
                            right: size.width * 0.04,
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: pink,
                            decoration: InputDecoration(
                              labelText: "メールアドレス",
                              labelStyle: TextStyle(
                                color: pink,
                                fontSize: size.width * 0.05,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: pink,
                                  width: size.width * 0.0025,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: pink,
                                  width: size.width * 0.0025,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: size.width * 0.04,
                            right: size.width * 0.04,
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: !_showPassword,
                            keyboardType: TextInputType.visiblePassword,
                            cursorColor: pink,
                            decoration: InputDecoration(
                              labelText: "パスワード",
                              labelStyle: TextStyle(
                                color: pink,
                                fontSize: size.width * 0.05,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showPassword
                                      ? FontAwesomeIcons.solidEyeSlash
                                      : FontAwesomeIcons.solidEye,
                                  color: pink,
                                  size: size.width * 0.05,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: pink,
                                  width: size.width * 0.0025,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: pink,
                                  width: size.width * 0.0025,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.only(
                              left: size.width * 0.04,
                              right: size.width * 0.04,
                            ),
                            child: GestureDetector(
                              child: Text(
                                'パスワードを忘れたら？',
                                style: TextStyle(
                                  color: pink,
                                  fontSize: size.width * 0.04,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  slideRoute(
                                    PasswordResetPage(userFB: _userFB),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                            left: size.width * 0.04,
                            right: size.width * 0.04,
                          ),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () async {
                                  if (_loading != true) {
                                    if (_emailController.text.length == 0 &&
                                        _passwordController.text.length == 0) {
                                      Flushbar(
                                        message: "メールアドレスとパスワードを入力してください。",
                                        backgroundColor: pink,
                                        duration: Duration(seconds: 3),
                                      )..show(context);
                                    } else if (_emailController.text.length ==
                                        0) {
                                      Flushbar(
                                        message: "メールアドレスを入力してください。",
                                        backgroundColor: pink,
                                        duration: Duration(seconds: 3),
                                      )..show(context);
                                    } else if (_passwordController
                                            .text.length ==
                                        0) {
                                      Flushbar(
                                        message: "パスワードを入力してください。",
                                        backgroundColor: pink,
                                        duration: Duration(seconds: 3),
                                      )..show(context);
                                    } else if (_passwordController.text.length <
                                        6) {
                                      Flushbar(
                                        message: "パスワードを6字以上で入力してください。",
                                        backgroundColor: pink,
                                        duration: Duration(seconds: 3),
                                      )..show(context);
                                    } else {
                                      FocusScope.of(context).unfocus();
                                      _loading = true;
                                      String _result =
                                          await _userFB.signInWithEmail(
                                              _emailController.text,
                                              _passwordController.text);
                                      if (_result == 'success') {
                                        final uid =
                                            await _userFB.getCurrentUserId();
                                        UserData _currentUser =
                                            await _userFB.getCurrentUser(uid);
                                        final isVerified =
                                            await _userFB.isEmailVerified();
                                        print('isVerified: $isVerified');
                                        if (isVerified) {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return NewNotificationPage(
                                                currentUser: _currentUser,
                                                appOpenUpdate:
                                                    (widget._fromMain == true)
                                                        ? false
                                                        : true,
                                              );
                                            }),
                                          );
                                          BlocProvider.of<AuthBloc>(context)
                                              .add(
                                            LogIn(currentUser: _currentUser),
                                          );
                                        } else {
                                          BlocProvider.of<AuthBloc>(context)
                                              .add(
                                            SignUp(gender: _currentUser.gender),
                                          );
                                          Navigator.of(context).push(
                                            slideRoute(
                                              EmailPage(
                                                userFB: _userFB,
                                                gender: _currentUser.gender,
                                              ),
                                            ),
                                          );
                                        }

                                        setState(() {
                                          _loading = false;
                                        });
//                                          Navigator.of(context)
//                                              .pushAndRemoveUntil(
//                                                  MaterialPageRoute(
//                                            builder: (context) {
//                                              return MyApp();
//                                            },
//                                          ), (_) => false);
                                      } else if (_result ==
                                          'ERROR_INVALID_EMAIL') {
                                        Flushbar(
                                          message: "メールアドレスが正しくありません。",
                                          backgroundColor: pink,
                                          duration: Duration(seconds: 3),
                                        )..show(context);
                                        setState(() {
                                          _loading = false;
                                        });
                                      } else {
                                        Flushbar(
                                          message: "しばらくしてからもう一度お試しください。",
                                          backgroundColor: pink,
                                          duration: Duration(seconds: 3),
                                        )..show(context);
                                        setState(() {
                                          _loading = false;
                                        });
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  width: size.width * 0.8,
                                  height: size.height * 0.06,
                                  decoration: BoxDecoration(
                                    color: pink,
                                    borderRadius: BorderRadius.circular(
                                      100,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "ログイン",
                                      style: TextStyle(
                                        fontSize: size.width * 0.05,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    slideRoute(
                                      SignUp1(userFB: _userFB),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: size.width * 0.8,
                                  height: size.height * 0.06,
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(
                                      100,
                                    ),
                                    border: Border.all(
                                      color: pink,
                                      width: size.width * 0.0025,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "アカウントを作成",
                                      style: TextStyle(
                                        fontSize: size.width * 0.05,
                                        color: pink,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              (MediaQuery.of(context).viewInsets.bottom > 0)
                                  ? SizedBox(
                                      height: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom)
                                  : Container(),
                            ],
                          ),
                        )
                      ],
                    ),
                    (_loading)
                        ? Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(pink),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
