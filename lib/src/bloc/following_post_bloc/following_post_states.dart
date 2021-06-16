import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class FollowingPostStates extends Equatable {
  const FollowingPostStates();

  @override
  List<Object> get props => [];
}

class FollowingPostInitFetchLoading extends FollowingPostStates {}

class FollowingPostFailure extends FollowingPostStates {}

class FollowingPostNoInternet extends FollowingPostStates {}

class FollowingPostSuccess extends FollowingPostStates {
  final List<Post> posts;
  final int activeAccountId;
  final bool hasReachedMax;
  final bool hasFailedToLoadMore;

  const FollowingPostSuccess({
    @required this.posts,
    @required this.activeAccountId,
    @required this.hasReachedMax,
    this.hasFailedToLoadMore = false,
  });

  @override
  List<Object> get props => [posts, hasReachedMax];

  @override
  String toString() =>
      'FollowingPostSuccess { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}
