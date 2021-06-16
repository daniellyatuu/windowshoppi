import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class AuthPostStates extends Equatable {
  const AuthPostStates();

  @override
  List<Object> get props => [];
}

class AuthPostInitFetchLoading extends AuthPostStates {}

class AuthPostFailure extends AuthPostStates {}

class AuthPostNoInternet extends AuthPostStates {}

class AuthPostSuccess extends AuthPostStates {
  final List<Post> posts;
  final int activeAccountId;
  final bool hasReachedMax;
  final bool hasFailedToLoadMore;

  const AuthPostSuccess({
    @required this.posts,
    @required this.activeAccountId,
    @required this.hasReachedMax,
    this.hasFailedToLoadMore = false,
  });

  @override
  List<Object> get props => [posts, hasReachedMax];

  @override
  String toString() =>
      'AuthPostSuccess { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}
