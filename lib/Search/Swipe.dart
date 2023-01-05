//著作権対策できる限りした。ちりあえずおけ
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttery_dart2/layout.dart';

typedef PhotoNumberCallback = void Function(int photoNumber);

class Swipe extends StatefulWidget {
  final Widget prof;
  final Widget profDetail;
  final bool front;
  final SwipeDirection swipeDirection;
  final DecisionIndicator showingPlace;
  final bool detail;
  final int photoNumber;
  final int photoCount;
  final PhotoNumberCallback photoNumberCallback;
  bool buildFirst;
  final Function(double distance) swipeUpdate;
  final Function(DecisionIndicator showingPlace) showingPlaceUpdate;
  final Function(SwipeDirection swipeDirection) swipeComplete;

  Swipe({
    this.prof,
    this.profDetail,
    this.front,
    this.swipeUpdate,
    this.swipeComplete,
    this.swipeDirection,
    this.showingPlace,
    this.showingPlaceUpdate,
    this.detail,
    this.photoNumber,
    this.photoCount,
    this.photoNumberCallback,
    this.buildFirst,
  });
  @override
  _SwipeState createState() => _SwipeState();
}

class _SwipeState extends State<Swipe> with TickerProviderStateMixin {
  Action decision;
  GlobalKey profKey = GlobalKey(debugLabel: 'profKey');
  Offset profOffset = const Offset(0.0, 0.0);
  SwipeDirection swipeCompleteDirection;
  Tween<Offset> swipeCompleteTween;
  DecisionIndicator showingDecision;
  AnimationController swipeCompleteAnimationController;
  AnimationController swipeBackAnimationController;
  bool detail;
  Offset swipeStart;
  Offset swipeStartBack;
  Offset swipePosition;
  int count;

  @override
  void initState() {
    count = 1;
    swipeBackAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )
      ..addListener(() => setState(() {
            if (widget.swipeUpdate != null) {
              widget.swipeUpdate(profOffset.distance);
            }

            if (widget.showingPlaceUpdate != null) {
              widget.showingPlaceUpdate(showingDecision);
            }
            profOffset = Offset.lerp(
              swipeStartBack,
              const Offset(0.0, 0.0),
              Curves.elasticOut.transform(swipeBackAnimationController.value),
            );
          }))
      ..addStatusListener(
        (AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            setState(
              () {
                swipeStart = null;
                swipeStartBack = null;
                swipePosition = null;
              },
            );
          }
        },
      );

    swipeCompleteAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(
        () {
          setState(
            () {
              profOffset =
                  swipeCompleteTween.evaluate(swipeCompleteAnimationController);
              if (widget.swipeUpdate != null) {
                widget.swipeUpdate(profOffset.distance);
              }
              if (widget.showingPlaceUpdate != null) {
                widget.showingPlaceUpdate(showingDecision);
              }
            },
          );
        },
      )
      ..addStatusListener(
        (AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            setState(
              () {
                count = 1;
                swipeStart = null;
                swipePosition = null;
                swipeCompleteTween = null;
                if (widget.swipeComplete != null) {
                  widget.swipeComplete(swipeCompleteDirection);
                }
              },
            );
          }
        },
      );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void didUpdateWidget(Swipe oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.prof.key != oldWidget.prof.key) {
      profOffset = const Offset(0.0, 0.0);
    }
    if (oldWidget.swipeDirection == null &&
        widget.swipeDirection != null &&
        count == 1) {
      count = count + 1;
      // ボタンだけがくる
      //TODO ここに連打したら何回もくるの問題
      if (widget.swipeDirection == SwipeDirection.buttonLeft) {
        _swipeLeft();
      } else if (widget.swipeDirection == SwipeDirection.buttonRight) {
        _swipeRight();
      } else if (widget.swipeDirection == SwipeDirection.buttonUp) {
        _swipeUp();
      }

//        case SlideDirection.undo:
//          _slideUp();
    }
  }

  @override
  void dispose() {
    swipeCompleteAnimationController.dispose();
    swipeBackAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (widget.buildFirst == true) {
      detail = false;
      widget.buildFirst = false;
//      widget.buildFirstCallback(false);
    }

    return AnchoredOverlay(
      showOverlay: true, //showOverlay.value,
      child: Center(),
      overlayBuilder: (BuildContext context, Rect rect, Offset offset) {
        return CenterAbout(
          position: offset,
          child: Transform(
            transform:
                Matrix4.translationValues(profOffset.dx, profOffset.dy, 0.0)
                  ..rotateZ(
                    _angle(rect),
                  ),
            origin: _angleOrigin(rect),
            child: Center(
              child: Container(
                alignment: Alignment.center,

                height: (rect.height > size.width * 1.5 &&
                        size.height -
                                size.width * 0.215 -
                                AppBar().preferredSize.height >
                            size.width * 1.5)
                    ? size.width * 1.5
                    : rect.height,
                width: (rect.height > size.width * 1.5 &&
                        size.height -
                                size.width * 0.215 -
                                AppBar().preferredSize.height >
                            size.width * 1.5)
                    ? size.width
                    : rect.width,
//                height: size.width * 1.5,
//                width: size.width,
                padding: EdgeInsets.only(
                  top: size.width * 0.012,
                  left: size.width * 0.012,
                  right: size.width * 0.012,
                  bottom: size.width * 0.012,
                ),
                key: profKey,
                child: (widget.front == false)
                    ? widget.prof
                    : (widget.detail == true || detail == true)
                        ? widget.profDetail
                        : GestureDetector(
                            //wt(detailをキープして写真変えたいとき: detailに関係なくdetail), wf(前面でみたいとき,次の人： detailがtrueならdetail, detailがnullならdetailじゃない(trueからnullならないので、wf1回目のbuildにdetail = false で　次からはなしにしたい)
                            //wn(detailをfalseにしたいマン)
                            // : t(detailにしたいとき), n(さわってsetstateされてしまったとき(detailの中でもsetstate無駄にされるときあんのか？ないとしたらfalseって意味でいい))
                            child: widget.prof,
                            onPanStart: _onPanStart,
                            onPanUpdate: _onPanUpdate,
                            onPanEnd: _onPanEnd,
                            onTapUp: _onTapUp,
                          ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _angle(Rect rect) {
    if (swipeStart != null) {
      return 0.1 * (profOffset.dx / rect.width);
    } else {
      return 0.0;
    }
  }

  Offset _angleOrigin(Rect rect) {
    if (swipeStart != null) {
      return swipeStart - rect.topLeft;
    } else {
      return const Offset(0.0, 0.0);
    }
  }

  void _onPanStart(DragStartDetails dragStartDetails) {
    swipeStart = dragStartDetails.globalPosition;
    if (swipeBackAnimationController.isAnimating) {
      swipeBackAnimationController.stop(canceled: true);
    }
  }

  void _onPanUpdate(DragUpdateDetails dragUpdateDetails) {
    setState(
      () {
        if (((profOffset.dx / context.size.width) < -0.15) ||
            ((profOffset.dx / context.size.width) > 0.15)) {
          showingDecision = ((profOffset.dx / context.size.width) < -0.15)
              ? DecisionIndicator.SkipPlace
              : DecisionIndicator.LikePlace;
        } else if ((profOffset.dy / context.size.height) < -0.15) {
          showingDecision = DecisionIndicator.SuperLikePlace;
        } else {
          showingDecision = null;
        }

        swipePosition = dragUpdateDetails.globalPosition;
        profOffset = swipePosition - swipeStart;

        if (widget.swipeUpdate != null) {
          widget.swipeUpdate(profOffset.distance);
        }

        if (widget.showingPlaceUpdate != null) {
          widget.showingPlaceUpdate(showingDecision);
        }
      },
    );
  }

  void _onPanEnd(DragEndDetails dragEndDetails) {
    setState(
      () {
        if ((profOffset.dx / context.size.width) < -0.15) {
          swipeCompleteTween = Tween(
              begin: profOffset,
              end: profOffset /
                  profOffset.distance *
                  (2.5 * context.size.width));
          swipeCompleteAnimationController.forward(from: 0.0);
          swipeCompleteDirection = SwipeDirection.left;
        } else if ((profOffset.dx / context.size.width) > 0.15) {
          swipeCompleteTween = Tween(
              begin: profOffset,
              end: profOffset /
                  profOffset.distance *
                  (2.5 * context.size.width));
          swipeCompleteAnimationController.forward(from: 0.0);
          swipeCompleteDirection = SwipeDirection.right;
        } else if ((profOffset.dy / context.size.height) < -0.35) {
          swipeCompleteTween = Tween(
              begin: profOffset,
              end:
                  profOffset / profOffset.distance * (2 * context.size.height));
          swipeCompleteAnimationController.forward(from: 0.0);
          swipeCompleteDirection = SwipeDirection.up;
        } else {
          swipeStartBack = profOffset;
          swipeBackAnimationController.forward(from: 0.0);
        }

        showingDecision = null;
        if (widget.showingPlaceUpdate != null) {
          widget.showingPlaceUpdate(showingDecision);
        }
      },
    );
  }

  void _onTapUp(TapUpDetails tapUpDetails) {
    Size size = MediaQuery.of(context).size;
    if ((tapUpDetails.globalPosition.dy / size.height) > 0.65) {
      setState(() {
        detail = true;
        //widget.photoNumberCallback(
        //                                    widget.photoNumber);
        //にしてsetstatecardstackで起こせばそっちからdistanceもらえるけどdetailのロジック「くみなおさなきゃ
      });
    } else if (tapUpDetails.globalPosition.dx / size.width < 0.5) {
      if (widget.photoNumber > 1) {
        widget.photoNumberCallback(widget.photoNumber - 1);
      }
      //profile cardのphotoを変更　　（or profile card毎いったる
    } else {
      if (widget.photoNumber < widget.photoCount) {
        widget.photoNumberCallback(widget.photoNumber + 1);
      }
    }
  }

  Offset _swipeStart() {
    final topLeft = (profKey.currentContext.findRenderObject() as RenderBox)
        .localToGlobal(const Offset(0.0, 0.0));
    return Offset(profKey.currentContext.size.width / 2 + topLeft.dx,
        profKey.currentContext.size.height * 0.4 + topLeft.dy);
  }

  void _swipeLeft() async {
    swipeCompleteDirection = SwipeDirection.left;
    await Future.delayed(Duration(milliseconds: 1)).then((_) {
      swipeCompleteTween = Tween(
          begin: const Offset(0.0, 0.0),
          end: Offset(-2.5 * context.size.width, 0.0));
      swipeStart = _swipeStart();
      swipeCompleteAnimationController.forward(from: 0.0);
    });
  }

  void _swipeRight() async {
    swipeCompleteDirection = SwipeDirection.right;
    await Future.delayed(Duration(milliseconds: 1)).then((_) {
      swipeCompleteTween = Tween(
          begin: const Offset(0.0, 0.0),
          end: Offset(2.5 * context.size.width, 0.0));
      swipeStart = _swipeStart();
      swipeCompleteAnimationController.forward(from: 0.0);
    });
  }

  void _swipeUp() async {
    swipeCompleteDirection = SwipeDirection.up;
    await Future.delayed(Duration(milliseconds: 1)).then((_) {
      swipeCompleteTween = Tween(
          begin: const Offset(0.0, 0.0),
          end: Offset(0.0, -2 * context.size.height));
      swipeCompleteAnimationController.forward(from: 0.0);
      swipeStart = _swipeStart();
    });
  }
}

enum SwipeDirection {
  left,
  right,
  up,
  buttonLeft,
  buttonRight,
  buttonUp,
}
enum DecisionIndicator { SkipPlace, LikePlace, SuperLikePlace }
