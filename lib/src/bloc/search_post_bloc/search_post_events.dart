import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class SearchPostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class ClearSearchPostResult extends SearchPostEvents {}

class InitSearchPostFetched extends SearchPostEvents {
  final String postKeyword;
  InitSearchPostFetched({@required this.postKeyword});

  @override
  List<Object> get props => [postKeyword];
}

class SearchPostLoadMore extends SearchPostEvents {}
