import 'package:equatable/equatable.dart';

abstract class FollowUnfollowStates extends Equatable {
  const FollowUnfollowStates();
  @override
  List<Object> get props => [];
}

class FollowLoading extends FollowUnfollowStates {}

class FollowSuccess extends FollowUnfollowStates {}

class FollowUnfollowNoInternet extends FollowUnfollowStates {}

class FollowUnfollowError extends FollowUnfollowStates {}
