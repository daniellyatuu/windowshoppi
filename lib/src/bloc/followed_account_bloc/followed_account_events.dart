import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class FollowedAccountEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveFollowedAccount extends FollowedAccountEvents {
  final int accountId;
  SaveFollowedAccount({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}

class SaveUnFollowedAccount extends FollowedAccountEvents {
  final int accountId;
  SaveUnFollowedAccount({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}
