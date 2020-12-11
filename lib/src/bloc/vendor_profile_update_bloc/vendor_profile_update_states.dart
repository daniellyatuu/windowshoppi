import 'package:windowshoppi/src/model/model_files.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class VendorProfileUpdateStates extends Equatable {
  const VendorProfileUpdateStates();
  @override
  List<Object> get props => [];
}

class VendorProfileUpdateFormEmpty extends VendorProfileUpdateStates {}

class VendorProfileUpdateSubmitting extends VendorProfileUpdateStates {}

class VendorProfileUpdateFormSubmitted extends VendorProfileUpdateStates {
  final User user;

  VendorProfileUpdateFormSubmitted({@required this.user});

  @override
  List<Object> get props => [user];
}

class VendorProfileUpdateUserExist extends VendorProfileUpdateStates {}

class VendorProfileUpdateFormError extends VendorProfileUpdateStates {}
