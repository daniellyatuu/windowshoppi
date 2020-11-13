import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class AuthenticationStates extends Equatable {
  const AuthenticationStates();
  @override
  List<Object> get props => [];
}

class AuthenticationLoading extends AuthenticationStates {}

class IsAuthenticated extends AuthenticationStates {
  final User user;
  final bool isLoggedIn;

  IsAuthenticated({@required this.user, @required this.isLoggedIn})
      : assert(user != null, isLoggedIn != null);

  @override
  List<Object> get props => [user, isLoggedIn];
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
