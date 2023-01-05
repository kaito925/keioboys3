//著作ok

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class SearchNewState extends Equatable {
  SearchNewState([List props = const []]) : super();
}

class LoadingState extends SearchNewState {
  @override
  List<Object> get props => [];
}

class LoadUserListState extends SearchNewState {
  final Stream<QuerySnapshot> userList;

  LoadUserListState({this.userList});

  @override
  List<Object> get props => [userList];
}
