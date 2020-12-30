import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/src/model/model_files.dart';

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
