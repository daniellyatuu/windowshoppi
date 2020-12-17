import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class SearchAccountEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class ClearSearchAccountResult extends SearchAccountEvents {}

class InitSearchAccountFetched extends SearchAccountEvents {
  final String accountKeyword;
  InitSearchAccountFetched({@required this.accountKeyword});

  @override
  List<Object> get props => [accountKeyword];
}

class SearchAccountLoadMore extends SearchAccountEvents {}
