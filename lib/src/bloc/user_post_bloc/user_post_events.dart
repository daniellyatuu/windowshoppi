import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class UserPostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class UserPostFetched extends UserPostEvents {
  final int accountId;
  UserPostFetched({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}
