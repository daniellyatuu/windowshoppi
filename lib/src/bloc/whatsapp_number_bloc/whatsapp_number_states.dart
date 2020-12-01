import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class WhatsappNumberStates extends Equatable {
  const WhatsappNumberStates();
  @override
  List<Object> get props => [];
}

class WhatsappNumberFormEmpty extends WhatsappNumberStates {}

class WhatsappNumberFormSubmitting extends WhatsappNumberStates {}

class WhatsappNumberFormSubmitted extends WhatsappNumberStates {
  final User user;

  WhatsappNumberFormSubmitted({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];
}

class WhatsappNumberFormError extends WhatsappNumberStates {}
