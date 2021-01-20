import 'package:equatable/equatable.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class UpdatePostStates extends Equatable {
  const UpdatePostStates();

  @override
  List<Object> get props => [];
}

class UpdatePostFormEmpty extends UpdatePostStates {}

class UpdatePostSubmitting extends UpdatePostStates {}

class UpdatePostSuccess extends UpdatePostStates {
  final Post newPost;

  UpdatePostSuccess({this.newPost});

  @override
  List<Object> get props => [newPost];
}

class UpdatePostError extends UpdatePostStates {}
