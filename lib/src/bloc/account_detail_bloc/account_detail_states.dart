import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class AccountDetailStates extends Equatable {
  const AccountDetailStates();
  @override
  List<Object> get props => [];
}

class AccountDetailLoading extends AccountDetailStates {}

class AccountDetailError extends AccountDetailStates {}

class AccountNotFound extends AccountDetailStates {}

class AccountDetailSuccess extends AccountDetailStates {
  final Account account;

  AccountDetailSuccess({@required this.account});

  @override
  List<Object> get props => [account];
}
