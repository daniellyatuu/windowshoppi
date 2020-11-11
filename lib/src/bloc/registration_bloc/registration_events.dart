import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class RegistrationEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveUserData extends RegistrationEvents {
  final dynamic data;
  SaveUserData({@required this.data}) : assert(data != null);

  @override
  List<Object> get props => [data];
}
