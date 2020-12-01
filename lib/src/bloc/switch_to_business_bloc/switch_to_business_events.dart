import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class SwitchToBusinessEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class SwitchToBusinessAccount extends SwitchToBusinessEvents {
  final int accountId;
  final int contactId;
  final dynamic data;

  SwitchToBusinessAccount({
    @required this.accountId,
    @required this.contactId,
    @required this.data,
  });

  @override
  List<Object> get props => [accountId, contactId, data];
}
