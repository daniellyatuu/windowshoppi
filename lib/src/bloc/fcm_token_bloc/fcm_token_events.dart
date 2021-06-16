import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class FcmTokenEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateToken extends FcmTokenEvents {
  final dynamic fcmToken;
  UpdateToken({@required this.fcmToken});

  @override
  List<Object> get props => [fcmToken];
}
