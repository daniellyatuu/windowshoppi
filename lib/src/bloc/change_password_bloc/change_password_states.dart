import 'package:equatable/equatable.dart';

abstract class ChangePasswordStates extends Equatable {
  const ChangePasswordStates();
  @override
  List<Object> get props => [];
}

class ChangePasswordFormEmpty extends ChangePasswordStates {}

class ChangePasswordFormSubmitting extends ChangePasswordStates {}

class ChangePasswordFormSubmitted extends ChangePasswordStates {}

class InvalidCurrentPassword extends ChangePasswordStates {}

class ChangePasswordFormError extends ChangePasswordStates {}
