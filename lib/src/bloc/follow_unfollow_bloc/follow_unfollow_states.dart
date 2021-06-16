import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class FollowUnfollowStates extends Equatable {
  const FollowUnfollowStates();
  @override
  List<Object> get props => [];
}

class FollowUnfollowInit extends FollowUnfollowStates {}

class FollowLoading extends FollowUnfollowStates {
  final int followingId;
  FollowLoading({@required this.followingId});

  @override
  List<Object> get props => [followingId];
}

class FollowSuccess extends FollowUnfollowStates {
  final int followingId;
  FollowSuccess({@required this.followingId});

  @override
  List<Object> get props => [followingId];
}

class UnfollowSuccess extends FollowUnfollowStates {
  final int unFollowingId;
  UnfollowSuccess({@required this.unFollowingId});

  @override
  List<Object> get props => [unFollowingId];
}

class FollowUnfollowNoInternet extends FollowUnfollowStates {}

class FollowUnfollowError extends FollowUnfollowStates {}
