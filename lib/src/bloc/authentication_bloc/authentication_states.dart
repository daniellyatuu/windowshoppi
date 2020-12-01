import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class AuthenticationStates extends Equatable {
  const AuthenticationStates();
  @override
  List<Object> get props => [];
}

class AuthenticationLoading extends AuthenticationStates {}

class AuthenticationError extends AuthenticationStates {}

class IsAuthenticated extends AuthenticationStates {
  final User user;
  final String notification;
  final dynamic isAlertDialogActive;

  IsAuthenticated({
    @required this.user,
    this.notification = 'no-notification',
    this.isAlertDialogActive,
  }) : assert(user != null);

  @override
  List<Object> get props => [user, notification, isAlertDialogActive];
}

class IsNotAuthenticated extends AuthenticationStates {
  final bool isAlreadyCreateAccount;
  final bool logout;

  IsNotAuthenticated(
      {@required this.isAlreadyCreateAccount, @required this.logout})
      : assert(isAlreadyCreateAccount != null, logout != null);

  @override
  List<Object> get props => [isAlreadyCreateAccount, logout];
}
