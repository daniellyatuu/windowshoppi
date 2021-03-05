import 'package:equatable/equatable.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class AllPostStates extends Equatable {
  const AllPostStates();

  @override
  List<Object> get props => [];
}

class AllPostInitial extends AllPostStates {}

class AllPostFailure extends AllPostStates {}

class AllPostNoInternet extends AllPostStates {}

class AllPostSuccess extends AllPostStates {
  final List<Post> posts;
  final bool hasReachedMax;
  final bool hasFailedToLoadMore;

  const AllPostSuccess(
      {this.posts, this.hasReachedMax, this.hasFailedToLoadMore = false});

  @override
  List<Object> get props => [posts, hasReachedMax];

  @override
  String toString() =>
      'AllPostSuccess { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}
