import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class LoginStates extends Equatable {
  const LoginStates();
  @override
  List<Object> get props => [];
}

class LoginFormEmpty extends LoginStates {}

class LoginFormSubmitting extends LoginStates {}

class ValidAccount extends LoginStates {
  final User user;

  ValidAccount({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}

class InvalidAccount extends LoginStates {}

class LoginFormError extends LoginStates {}
