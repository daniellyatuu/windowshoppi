import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class WindowshopperProfileUpdateEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateWindowshopperProfile extends WindowshopperProfileUpdateEvents {
  final int accountId;
  final int contactId;
  final dynamic data;
  UpdateWindowshopperProfile(
      {@required this.accountId, @required this.contactId, @required this.data})
      : assert(contactId != null, data != null);

  @override
  List<Object> get props => [accountId, contactId, data];
}
