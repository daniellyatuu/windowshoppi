import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class AccountInfoEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class GetAccountInfo extends AccountInfoEvents {
  final int accountId;
  GetAccountInfo({@required this.accountId});
}

class IncrementPostNo extends AccountInfoEvents {}

class DecrementPostNo extends AccountInfoEvents {}

class IncrementFollowing extends AccountInfoEvents {}

class DecrementFollowing extends AccountInfoEvents {}
