import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class NetworkStates extends Equatable {
  const NetworkStates();
  @override
  List<Object> get props => [];
}

class ConnectionInitial extends NetworkStates {}

class ConnectionSuccess extends NetworkStates {
  final NetworkStates prevState;
  ConnectionSuccess({@required this.prevState});

  @override
  List<Object> get props => [prevState];
}

class ConnectionFailure extends NetworkStates {}
