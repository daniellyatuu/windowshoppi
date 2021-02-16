import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class NavigationEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class ChangeIndex extends NavigationEvents {
  final int index;
  ChangeIndex({@required this.index});

  @override
  List<Object> get props => [index];
}
