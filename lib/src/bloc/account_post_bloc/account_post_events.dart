import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class AccountPostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class AccountPostInitFetched extends AccountPostEvents {
  final int accountId;
  AccountPostInitFetched({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}

class AccountPostFetchedMoreData extends AccountPostEvents {
  final int accountId;
  AccountPostFetchedMoreData({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}

class AccountPostRefresh extends AccountPostEvents {
  final int accountId;
  AccountPostRefresh({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}

class AccountPostRemove extends AccountPostEvents {
  final Post post;

  AccountPostRemove({this.post});

  @override
  List<Object> get props => [post];
}

class ResetAccountPostState extends AccountPostEvents {}
