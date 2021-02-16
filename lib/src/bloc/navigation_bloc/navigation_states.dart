import 'package:equatable/equatable.dart';

abstract class NavigationStates extends Equatable {
  const NavigationStates();

  @override
  List<Object> get props => [];
}

class CurrentIndex extends NavigationStates {
  final int index;
  CurrentIndex({this.index = 0});

  @override
  List<Object> get props => [index];
}
