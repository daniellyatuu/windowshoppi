import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ScrollToTopEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class ScrollToTop extends ScrollToTopEvents {
  final int index;
  ScrollToTop({@required this.index});

  @override
  List<Object> get props => [index];
}
