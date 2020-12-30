import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class AccountPostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class AccountPostFetched extends AccountPostEvents {
  final int accountId;
  AccountPostFetched({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}

class AccountPostRefresh extends AccountPostEvents {
  final int accountId;
  AccountPostRefresh({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}
