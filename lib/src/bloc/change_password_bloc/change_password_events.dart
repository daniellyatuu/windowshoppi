import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class ChangePasswordEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateUserPassword extends ChangePasswordEvents {
  final dynamic data;
  UpdateUserPassword({@required this.data});

  @override
  List<Object> get props => [data];
}
