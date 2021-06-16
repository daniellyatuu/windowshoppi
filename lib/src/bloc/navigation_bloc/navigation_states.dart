import 'package:equatable/equatable.dart';

abstract class NavigationStates extends Equatable {
  const NavigationStates();

  @override
  List<Object> get props => [];
}

class AppCurrentIndex extends NavigationStates {
  final int index;
  AppCurrentIndex({this.index = 0});

  @override
  List<Object> get props => [index];
}
