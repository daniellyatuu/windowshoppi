import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class AccountDetailEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetAccountDetail extends AccountDetailEvents {
  final int accountId;

  GetAccountDetail({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}
