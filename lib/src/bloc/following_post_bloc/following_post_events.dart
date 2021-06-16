import 'package:windowshoppi/src/model/model_files.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class FollowingPostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class FollowingPostInitFetch extends FollowingPostEvents {
  final int accountId;
  FollowingPostInitFetch({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}

class FollowingPostLoadMore extends FollowingPostEvents {}

class FollowingPostRefresh extends FollowingPostEvents {
  final int accountId;
  FollowingPostRefresh({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}

// class AllPostFetched extends AllPostEvents {
//   final String from;
//   AllPostFetched({this.from = 'home'});
// }
//
// class AllPostRefresh extends AllPostEvents {}
//
class FollowingAllPostInsert extends FollowingPostEvents {
  final Post post;

  FollowingAllPostInsert({this.post});

  @override
  List<Object> get props => [post];
}

class FollowingPostRemove extends FollowingPostEvents {
  final Post post;

  FollowingPostRemove({this.post});

  @override
  List<Object> get props => [post];
}

// class AllPostRetry extends AllPostEvents {}
