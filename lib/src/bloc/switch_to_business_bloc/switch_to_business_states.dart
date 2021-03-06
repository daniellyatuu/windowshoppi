import 'package:windowshoppi/src/model/model_files.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class SwitchToBusinessStates extends Equatable {
  const SwitchToBusinessStates();
  @override
  List<Object> get props => [];
}

class SwitchToBusinessFormEmpty extends SwitchToBusinessStates {}

class SwitchToBusinessSubmitting extends SwitchToBusinessStates {}

class SwitchToBusinessFormSubmitted extends SwitchToBusinessStates {
  final User user;

  SwitchToBusinessFormSubmitted({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}

class SwitchToBusinessUserExist extends SwitchToBusinessStates {}

class SwitchAccountNoInternet extends SwitchToBusinessStates {}

class SwitchToBusinessFormError extends SwitchToBusinessStates {}
