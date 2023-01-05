import 'package:bloc/bloc.dart';
//
//class SimpleBlocDelegate extends BlocDelegate {
//  @override
//  void onError(Object error, StackTrace stacktrace) {
//    super.onError(error, stacktrace);
//  }

//  @override
//  void onTransition(Transition transition) {
//    super.onTransition(transition);
//  }
//}

class MyBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase blocBase, Object error, StackTrace stackTrace) {
    super.onError(blocBase, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }
}
