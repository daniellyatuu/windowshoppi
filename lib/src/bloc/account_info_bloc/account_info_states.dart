import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class AccountInfoStates extends Equatable {
  const AccountInfoStates();
  @override
  List<Object> get props => [];
}

class AccountInfoLoading extends AccountInfoStates {}

class AccountInfoError extends AccountInfoStates {}

class AccountInfoNotFound extends AccountInfoStates {}

class AccountInfoSuccess extends AccountInfoStates {
  final AccountInfo accountInfo;

  AccountInfoSuccess({@required this.accountInfo});

  @override
  List<Object> get props => [accountInfo];
}
