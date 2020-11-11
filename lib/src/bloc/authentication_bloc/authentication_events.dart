import 'package:equatable/equatable.dart';

abstract class AuthenticationEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckUserLoggedInStatus extends AuthenticationEvents {}

class UserLoggedIn extends AuthenticationEvents {}

class UserLoggedOut extends AuthenticationEvents {}
