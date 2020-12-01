import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class VendorProfileUpdateEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateVendorProfile extends VendorProfileUpdateEvents {
  final int accountId;
  final int contactId;
  final dynamic data;
  UpdateVendorProfile({
    @required this.accountId,
    @required this.contactId,
    @required this.data,
  });

  @override
  List<Object> get props => [accountId, contactId, data];
}
