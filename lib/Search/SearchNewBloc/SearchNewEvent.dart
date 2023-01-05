//著作ok
import 'package:equatable/equatable.dart';

abstract class SearchNewEvent extends Equatable {
  SearchNewEvent([List props = const []]) : super();
}

class GetUserEvent extends SearchNewEvent {
  final String interestedGender;

  GetUserEvent({this.interestedGender});

  @override
  List<Object> get props => [interestedGender];
}
