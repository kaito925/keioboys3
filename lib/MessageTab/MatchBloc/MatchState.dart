//著作ok

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class LikedAndMatchState extends Equatable {
  LikedAndMatchState([List props = const []]) : super();
}

class LoadingState extends LikedAndMatchState {
  @override
  List<Object> get props => [];
}

class LoadAgeVerificationState extends LikedAndMatchState {
  final Stream<DocumentSnapshot> ageVerificationSnapshot;

  LoadAgeVerificationState({
    this.ageVerificationSnapshot,
  });

  @override
  List<Object> get props => [
        ageVerificationSnapshot,
      ];
}

class LoadLikedListState extends LikedAndMatchState {
  final Stream<QuerySnapshot> likedList;
  final Stream<QuerySnapshot> superLikedList;

  LoadLikedListState({
    this.likedList,
    this.superLikedList,
  });

  @override
  List<Object> get props => [
        likedList,
        superLikedList,
      ];
}

class LoadMatchUserState extends LikedAndMatchState {
  final Stream<QuerySnapshot> matchList;

  LoadMatchUserState({this.matchList});

  @override
  List<Object> get props => [matchList];
}
