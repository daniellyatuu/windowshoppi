import 'package:windowshoppi/src/model/model_files.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class AuthPostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthPostInitFetch extends AuthPostEvents {
  final int accountId;
  AuthPostInitFetch({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}

class AuthPostLoadMore extends AuthPostEvents {}

class AuthPostRefresh extends AuthPostEvents {
  final int accountId;
  AuthPostRefresh({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}

// class AllPostFetched extends AllPostEvents {
//   final String from;
//   AllPostFetched({this.from = 'home'});
// }
//
// class AllPostRefresh extends AllPostEvents {}
//
class AuthAllPostInsert extends AuthPostEvents {
  final Post post;

  AuthAllPostInsert({this.post});

  @override
  List<Object> get props => [post];
}

class AuthPostRemove extends AuthPostEvents {
  final Post post;

  AuthPostRemove({this.post});

  @override
  List<Object> get props => [post];
}

// class AllPostRetry extends AllPostEvents {}
