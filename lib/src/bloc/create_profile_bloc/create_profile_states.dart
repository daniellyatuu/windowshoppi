import 'package:equatable/equatable.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class CreateProfileStates extends Equatable {
  const CreateProfileStates();

  @override
  List<Object> get props => [];
}

// create profile events
class CreateProfileFormEmpty extends CreateProfileStates {}

class CreateProfileSubmitting extends CreateProfileStates {}

class CreateProfileSuccess extends CreateProfileStates {
  final User user;

  CreateProfileSuccess({this.user});

  @override
  List<Object> get props => [user];
}

class CreateProfileError extends CreateProfileStates {}

// remove profile events
class RemoveProfileLoading extends CreateProfileStates {}

class RemoveProfileSuccess extends CreateProfileStates {
  final User user;

  RemoveProfileSuccess({this.user});

  @override
  List<Object> get props => [user];
}

class RemoveProfileError extends CreateProfileStates {}
