// import 'package:equatable/equatable.dart';
// import 'package:windowshoppi/models/post.dart';
//
// abstract class PostState extends Equatable {
//   const PostState();
//
//   @override
//   List<Object> get props => [];
// }
//
// class PostInitial extends PostState {}
//
// class PostFailure extends PostState {}
//
// class PostSuccess extends PostState {
//   final List<Post> posts;
//   final bool hasReachedMax;
//
//   const PostSuccess({
//     this.posts,
//     this.hasReachedMax,
//   });
//
//   PostSuccess copyWith({List<Post> posts, bool hasReachedMax}) {
//     return PostSuccess(
//       posts: posts ?? this.posts,
//       hasReachedMax: hasReachedMax ?? this.hasReachedMax,
//     );
//   }
//
//   @override
//   List<Object> get props => [posts, hasReachedMax];
//
//   @override
//   String toString() =>
//       'PostSuccess { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
// }

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:windowshoppi/models/models.dart';

abstract class PostStates extends Equatable {
  const PostStates();
  @override
  List<Object> get props => [];
}

class PostEmpty extends PostStates {}

class PostLoading extends PostStates {}

class PostLoaded extends PostStates {
  final List<Post> post;

  PostLoaded({@required this.post}) : assert(post != null);

  @override
  List<Object> get props => [post];
}

class PostError extends PostStates {}
