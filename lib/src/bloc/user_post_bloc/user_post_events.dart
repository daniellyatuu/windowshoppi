import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class UserPostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class UserPostFetched extends UserPostEvents {
  final int accountId;
  UserPostFetched({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}

class UserPostInsert extends UserPostEvents {
  final Post post;

  UserPostInsert({this.post});

  @override
  List<Object> get props => [post];
}

class UserPostRefresh extends UserPostEvents {
  final int accountId;
  UserPostRefresh({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}
