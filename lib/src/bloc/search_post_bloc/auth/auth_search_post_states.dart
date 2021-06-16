import 'package:equatable/equatable.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class AuthSearchPostStates extends Equatable {
  const AuthSearchPostStates();

  @override
  List<Object> get props => [];
}

class AuthSearchPostEmpty extends AuthSearchPostStates {}

class AuthSearchPostInitial extends AuthSearchPostStates {}

class AuthSearchPostFailure extends AuthSearchPostStates {}

class AuthSearchPostSuccess extends AuthSearchPostStates {
  final List<Post> posts;
  final bool hasReachedMax;
  final String searchedKeyword;

  const AuthSearchPostSuccess({
    this.posts,
    this.hasReachedMax,
    this.searchedKeyword,
  });

  @override
  List<Object> get props => [posts, hasReachedMax, searchedKeyword];

  @override
  String toString() =>
      'SearchPostSuccess { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}
