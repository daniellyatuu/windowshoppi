import 'package:equatable/equatable.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class AccountPostStates extends Equatable {
  const AccountPostStates();

  @override
  List<Object> get props => [];
}

class AccountPostInitial extends AccountPostStates {}

class AccountPostFailure extends AccountPostStates {}

class AccountPostSuccess extends AccountPostStates {
  final List<Post> posts;
  final bool hasReachedMax;

  const AccountPostSuccess({this.posts, this.hasReachedMax});

  @override
  List<Object> get props => [posts, hasReachedMax];

  @override
  String toString() =>
      'AccountPostSuccess { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}
