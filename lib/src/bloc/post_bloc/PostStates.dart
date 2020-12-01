import 'package:equatable/equatable.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class PostStates extends Equatable {
  const PostStates();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostStates {}

class PostFailure extends PostStates {}

class PostSuccess extends PostStates {
  final List<Post> posts;
  final bool hasReachedMax;

  const PostSuccess({
    this.posts,
    this.hasReachedMax,
  });

  PostSuccess copyWith({
    List<Post> posts,
    bool hasReachedMax,
  }) {
    return PostSuccess(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [posts, hasReachedMax];

  @override
  String toString() =>
      'PostSuccess { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}
