import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class RegistrationStates extends Equatable {
  const RegistrationStates();
  @override
  List<Object> get props => [];
}

class FormEmpty extends RegistrationStates {}

class FormSubmitting extends RegistrationStates {}

class FormSubmitted extends RegistrationStates {
  final User user;

  FormSubmitted({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}

class FormError extends RegistrationStates {
  final dynamic error;
  FormError({@required this.error}) : assert(error != null);
}

class UserExist extends RegistrationStates {}
