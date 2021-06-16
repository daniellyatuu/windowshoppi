import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class FcmTokenStates extends Equatable {
  const FcmTokenStates();
  @override
  List<Object> get props => [];
}

class FcmTokenInit extends FcmTokenStates {}

class FcmTokenUpdatedSuccessfully extends FcmTokenStates {}
