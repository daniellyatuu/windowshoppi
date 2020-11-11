import 'package:equatable/equatable.dart';

abstract class RegistrationStates extends Equatable {
  const RegistrationStates();
  @override
  List<Object> get props => [];
}

class FormEmpty extends RegistrationStates {}

class FormSubmitting extends RegistrationStates {}

class FormSubmitted extends RegistrationStates {}

class FormError extends RegistrationStates {}

class UserExist extends RegistrationStates {}
