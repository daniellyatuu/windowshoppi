import 'package:equatable/equatable.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class DeletePostStates extends Equatable {
  const DeletePostStates();

  @override
  List<Object> get props => [];
}

class DeletePostLoading extends DeletePostStates {}

class DeletePostError extends DeletePostStates {}

class DeletePostSuccess extends DeletePostStates {}
