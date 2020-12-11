import 'package:equatable/equatable.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class UserPostStates extends Equatable {
  const UserPostStates();

  @override
  List<Object> get props => [];
}

class UserPostInitial extends UserPostStates {}

class UserPostFailure extends UserPostStates {}

class InvalidToken extends UserPostStates {}

class UserPostSuccess extends UserPostStates {
  final List<Post> posts;
  final bool hasReachedMax;

  const UserPostSuccess({this.posts, this.hasReachedMax});

  UserPostSuccess copyWith({List<Post> posts, bool hasReachedMax}) {
    return UserPostSuccess(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [posts, hasReachedMax];

  @override
  String toString() =>
      'UserPostSuccess { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}
