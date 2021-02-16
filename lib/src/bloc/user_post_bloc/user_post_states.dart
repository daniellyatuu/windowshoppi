import 'package:equatable/equatable.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class UserPostStates extends Equatable {
  const UserPostStates();

  @override
  List<Object> get props => [];
}

class UserPostInitial extends UserPostStates {}

class UserPostInitNoInternet extends UserPostStates {}

class UserPostLoadMoreNoInternet extends UserPostStates {}

class UserPostFailure extends UserPostStates {}

class InvalidToken extends UserPostStates {}

class UserPostSuccess extends UserPostStates {
  final List<Post> posts;
  final bool hasReachedMax;
  final bool hasFailedToLoadMore;

  const UserPostSuccess(
      {this.posts, this.hasReachedMax, this.hasFailedToLoadMore = false});

  @override
  List<Object> get props => [posts, hasReachedMax, hasFailedToLoadMore];

  @override
  String toString() =>
      'UserPostSuccess { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}
