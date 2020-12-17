import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class SearchTextFieldEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class UserTypeOnSearchField extends SearchTextFieldEvents {
  final String keyword;
  UserTypeOnSearchField({@required this.keyword});

  @override
  List<Object> get props => [keyword];
}

class CheckSearchedKeyword extends SearchTextFieldEvents {}

class ClearSearchedKeyword extends SearchTextFieldEvents {}
