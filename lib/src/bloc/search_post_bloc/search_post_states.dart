import 'package:equatable/equatable.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class SearchPostStates extends Equatable {
  const SearchPostStates();

  @override
  List<Object> get props => [];
}

class SearchPostEmpty extends SearchPostStates {}

class SearchPostInitial extends SearchPostStates {}

class SearchPostFailure extends SearchPostStates {}

class SearchPostSuccess extends SearchPostStates {
  final List<Post> posts;
  final bool hasReachedMax;
  final String searchedKeyword;

  const SearchPostSuccess({
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
