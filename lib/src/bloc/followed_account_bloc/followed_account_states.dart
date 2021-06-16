import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class FollowedAccountStates extends Equatable {
  const FollowedAccountStates();
  @override
  List<Object> get props => [];
}

class FollowedAccountInit extends FollowedAccountStates {}

class FollowedLoading extends FollowedAccountStates {}

class FollowedUnfollowedAccounts extends FollowedAccountStates {
  final List<int> followedAccounts;
  final List<int> unfollowedAccounts;
  FollowedUnfollowedAccounts(
      {@required this.followedAccounts, @required this.unfollowedAccounts});

  @override
  List<Object> get props => [followedAccounts];
}
