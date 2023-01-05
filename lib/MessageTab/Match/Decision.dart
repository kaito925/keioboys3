//著作ok

import 'package:Keioboys/Widgets/UserData.dart';
import 'package:flutter/material.dart';

class Decision extends ChangeNotifier {
  final UserData selectedUser;

  SwipeDecision swipeDecision = SwipeDecision.undecided;
  Decision({this.selectedUser});

  void like() {
    if (swipeDecision == SwipeDecision.undecided) {
      swipeDecision = SwipeDecision.like;
      notifyListeners();
    }
  }

  void skip() {
    if (swipeDecision == SwipeDecision.undecided) {
      swipeDecision = SwipeDecision.skip;
      notifyListeners();
    }
  }

  void superLike() {
    if (swipeDecision == SwipeDecision.undecided) {
      swipeDecision = SwipeDecision.superLike;
      notifyListeners();
    }
  }

  void buttonLike() {
    print('soso');

    if (swipeDecision == SwipeDecision.undecided) {
      print('soso');
      swipeDecision = SwipeDecision.buttonLike;
      notifyListeners();
    }
  }

  void buttonSkip() {
    if (swipeDecision == SwipeDecision.undecided) {
      swipeDecision = SwipeDecision.buttonSkip;
      notifyListeners();
    }
  }

  void buttonSuperLike() {
    if (swipeDecision == SwipeDecision.undecided) {
      swipeDecision = SwipeDecision.buttonSuperLike;
      notifyListeners();
    }
  }

//  void undo() {
//    if (decision == Decision.undecided) {
//      decision = Decision.undo;
//      notifyListeners();
//    }
//  }

  void undecided() {
    if (swipeDecision != SwipeDecision.undecided) {
      swipeDecision = SwipeDecision.undecided;
      notifyListeners();
    }
  }
}

enum SwipeDecision {
  undecided,
  skip,
  like,
  superLike,
  buttonSkip,
  buttonLike,
  buttonSuperLike,
//  undo,
}
