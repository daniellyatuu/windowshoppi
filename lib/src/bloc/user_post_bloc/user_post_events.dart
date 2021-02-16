import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class UserPostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class UserPostFetchedInit extends UserPostEvents {
  final int accountId;
  UserPostFetchedInit({@required this.accountId});

  @override
  List<Object> get props => [accountId];
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

class UserPostRemove extends UserPostEvents {
  final Post post;

  UserPostRemove({this.post});

  @override
  List<Object> get props => [post];
}

class ReplacePost extends UserPostEvents {
  final Post prevPost;
  final Post newPost;
  ReplacePost({this.prevPost, this.newPost});

  @override
  List<Object> get props => [prevPost, newPost];
}

class UserPostRefresh extends UserPostEvents {
  final int accountId;
  UserPostRefresh({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}
