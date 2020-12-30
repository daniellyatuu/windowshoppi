import 'package:equatable/equatable.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class ScrollToTopStates extends Equatable {
  const ScrollToTopStates();

  @override
  List<Object> get props => [];
}

class ScrollToTopInitial extends ScrollToTopStates {}

class IndexZeroScrollToTop extends ScrollToTopStates {}

class IndexOneScrollToTop extends ScrollToTopStates {}

class IndexTwoScrollToTop extends ScrollToTopStates {}

class IndexThreeScrollToTop extends ScrollToTopStates {}
