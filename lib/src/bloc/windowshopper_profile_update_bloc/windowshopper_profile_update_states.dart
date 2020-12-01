import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class WindowshopperProfileUpdateStates extends Equatable {
  const WindowshopperProfileUpdateStates();
  @override
  List<Object> get props => [];
}

class WindowshopperProfileUpdateFormEmpty
    extends WindowshopperProfileUpdateStates {}

class WindowshopperProfileUpdateSubmitting
    extends WindowshopperProfileUpdateStates {}

class WindowshopperProfileUpdateFormSubmitted
    extends WindowshopperProfileUpdateStates {
  final User user;

  WindowshopperProfileUpdateFormSubmitted({@required this.user})
      : assert(user != null);

  @override
  List<Object> get props => [user];
}

class WindowshopperProfileUpdateUserExist
    extends WindowshopperProfileUpdateStates {}

class WindowshopperProfileUpdateFormError
    extends WindowshopperProfileUpdateStates {}
