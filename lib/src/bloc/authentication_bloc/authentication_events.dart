import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class AuthenticationEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckUserLoggedInStatus extends AuthenticationEvents {}

class UserLoggedIn extends AuthenticationEvents {
  final User user;
  final dynamic isAlertDialogActive;

  UserLoggedIn({@required this.user, @required this.isAlertDialogActive})
      : assert(user != null, isAlertDialogActive != null);

  @override
  List<Object> get props => [user, isAlertDialogActive];
}

class UserUpdated extends AuthenticationEvents {
  final User user;
  final dynamic isAlertDialogActive;

  UserUpdated({@required this.user, @required this.isAlertDialogActive})
      : assert(user != null, isAlertDialogActive != null);

  @override
  List<Object> get props => [user, isAlertDialogActive];
}

class UserLoggedOut extends AuthenticationEvents {}

class UserVisitLoginRegister extends AuthenticationEvents {
  final String redirectTo;
  UserVisitLoginRegister({@required this.redirectTo});

  @override
  List<Object> get props => [redirectTo];
}

class DeleteToken extends AuthenticationEvents {}
