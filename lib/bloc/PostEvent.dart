// import 'package:equatable/equatable.dart';
//
// abstract class PostEvent extends Equatable {
//   @override
//   List<Object> get props => [];
// }
//
// class PostFetched extends PostEvent {}

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class PostEvents extends Equatable {
  const PostEvents();
}

class FetchPosts extends PostEvents {
  final String keyword;
  FetchPosts({@required this.keyword}) : assert(keyword != null);

  @override
  List<Object> get props => [keyword];
}

class RefreshPosts extends PostEvents {
  final String keyword;
  const RefreshPosts({@required this.keyword}) : assert(keyword != null);

  @override
  List<Object> get props => [keyword];
}

class ResetPosts extends PostEvents {
  @override
  List<Object> get props => null;
}
