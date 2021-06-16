import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class FollowUnfollowEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class FollowAccount extends FollowUnfollowEvents {
  final dynamic followData;
  FollowAccount({@required this.followData});

  @override
  List<Object> get props => [followData];
}
