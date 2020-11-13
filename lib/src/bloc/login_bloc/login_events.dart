import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class LoginEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class UserLogin extends LoginEvents {
  final dynamic data;
  UserLogin({@required this.data}) : assert(data != null);

  @override
  List<Object> get props => [data];
}
