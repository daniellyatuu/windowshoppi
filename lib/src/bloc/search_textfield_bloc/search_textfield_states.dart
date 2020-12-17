import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class SearchTextFieldStates extends Equatable {
  const SearchTextFieldStates();
  @override
  List<Object> get props => [];
}

class SearchTextFieldLoading extends SearchTextFieldStates {}

class SearchTextFieldEmpty extends SearchTextFieldStates {}

class SearchTextFieldNotEmpty extends SearchTextFieldStates {
  final String keyword;
  const SearchTextFieldNotEmpty({@required this.keyword});

  @override
  List<Object> get props => [keyword];
}
