import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class RegistrationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveUserData extends RegistrationEvent {
  final dynamic data;
  SaveUserData({@required this.data}) : assert(data != null);

  @override
  List<Object> get props => [data];
}
