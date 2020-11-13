import 'package:equatable/equatable.dart';

abstract class LoginStates extends Equatable {
  const LoginStates();
  @override
  List<Object> get props => [];
}

class LoginFormEmpty extends LoginStates {}

class LoginFormSubmitting extends LoginStates {}

class ValidAccount extends LoginStates {}

class InvalidAccount extends LoginStates {}

class LoginFormError extends LoginStates {}
