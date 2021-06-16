import 'package:windowshoppi/src/model/model_files.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class NotificationEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class NotificationInitFetch extends NotificationEvents {
  final int accountId;
  NotificationInitFetch({@required this.accountId});

  @override
  List<Object> get props => [accountId];
}

class NotificationLoadMore extends NotificationEvents {}

class NotificationRefresh extends NotificationEvents {}
