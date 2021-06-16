import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class OtherAccountInfoStates extends Equatable {
  const OtherAccountInfoStates();
  @override
  List<Object> get props => [];
}

class OtherAccountInfoLoading extends OtherAccountInfoStates {}

class OtherAccountInfoError extends OtherAccountInfoStates {}

class OtherAccountInfoNotFound extends OtherAccountInfoStates {}

class OtherAccountInfoSuccess extends OtherAccountInfoStates {
  final AccountInfo accountInfo;

  OtherAccountInfoSuccess({@required this.accountInfo});

  @override
  List<Object> get props => [accountInfo];
}
