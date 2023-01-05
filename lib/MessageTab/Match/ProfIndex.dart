//著作件ok

import 'package:flutter/widgets.dart';
import 'package:Keioboys/MessageTab/Match/Decision.dart';

class ProfIndex extends ChangeNotifier {
  final List<Decision> _decisions;
  int _beforeProfIndex;
  int _currentProfIndex;
  int _nextProfIndex;

  ProfIndex({
    List<Decision> decisions,
  }) : _decisions = decisions {
    _beforeProfIndex = 0;
    _currentProfIndex = 0;
    (_decisions.length < 2) ? _nextProfIndex = 0 : _nextProfIndex = 1;
//    _nextMatchIndex = math.Random().nextInt(_matches.length);
  }

  Decision get beforeProf => _decisions[_beforeProfIndex];
  Decision get currentProf => _decisions[_currentProfIndex];
  Decision get nextProf => _decisions[_nextProfIndex];

  void nextIndex() {
    //次のひとへ
    if (currentProf.swipeDecision != SwipeDecision.undecided) {
      //currentMatch.resetMatch();
      _beforeProfIndex = _currentProfIndex;
      _currentProfIndex = _nextProfIndex;

//      _nextMatchIndex = _nextMatchIndex +
//          1;
//      _nextMatchIndex = math.Random().nextInt(_matches.length);

      (_nextProfIndex < _decisions.length - 1)
          ? _nextProfIndex = _nextProfIndex + 1
          : _nextProfIndex = 0;
      notifyListeners();
    }
  }

//  void undoMatch() {
//    if (currentSearch.decision != Decision.undecided) {
//      _matches.insert(_nextMatchIndex, _matches[_beforeMatchIndex]);
//      _nextMatchIndex = _currentMatchIndex;
//      _currentMatchIndex = _beforeMatchIndex;

//      (_nextMatchIndex < _matches.length - 1)
//          ? _nextMatchIndex = _nextMatchIndex + 1
//          : _nextMatchIndex = 0;
//      notifyListeners();
//    }
//  }
}
