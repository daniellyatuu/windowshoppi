import 'package:equatable/equatable.dart';

abstract class AuthenticationStates extends Equatable {
  const AuthenticationStates();
  @override
  List<Object> get props => [];
}

class AuthenticationLoading extends AuthenticationStates {}

class IsAuthenticated extends AuthenticationStates {}

class IsNotAuthenticated extends AuthenticationStates {}
