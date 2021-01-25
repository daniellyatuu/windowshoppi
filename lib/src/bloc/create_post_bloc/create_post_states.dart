import 'package:equatable/equatable.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class CreatePostStates extends Equatable {
  const CreatePostStates();

  @override
  List<Object> get props => [];
}

class CreatePostFormEmpty extends CreatePostStates {}

class CreatePostSubmitting extends CreatePostStates {}

class CreatePostSuccess extends CreatePostStates {
  final Post post;

  CreatePostSuccess({this.post});

  @override
  List<Object> get props => [post];
}

class CreatePostNoInternet extends CreatePostStates {}

class CreatePostError extends CreatePostStates {}
