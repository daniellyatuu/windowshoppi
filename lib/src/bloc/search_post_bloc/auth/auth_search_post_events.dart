import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthSearchPostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthClearSearchPostResult extends AuthSearchPostEvents {}

class AuthInitSearchPostFetched extends AuthSearchPostEvents {
  final String postKeyword;
  final int accountId;
  AuthInitSearchPostFetched(
      {@required this.postKeyword, @required this.accountId});

  @override
  List<Object> get props => [postKeyword, accountId];
}

class AuthSearchPostLoadMore extends AuthSearchPostEvents {
  final int accountId;
  AuthSearchPostLoadMore({@required this.accountId});
  @override
  List<Object> get props => [accountId];
}
