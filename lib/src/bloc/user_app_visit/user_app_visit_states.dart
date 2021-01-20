import 'package:equatable/equatable.dart';

abstract class UserAppVisitStates extends Equatable {
  const UserAppVisitStates();

  @override
  List<Object> get props => [];
}

class UserAppVisitInitial extends UserAppVisitStates {}

class IsFirstTime extends UserAppVisitStates {}

class IsNotFirstTime extends UserAppVisitStates {}
