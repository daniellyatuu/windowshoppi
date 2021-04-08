import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class FollowUnfollowEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class FollowAccount extends FollowUnfollowEvents {
  final int accountId;
  FollowAccount({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}
