import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:windowshoppi/src/model/model_files.dart';

abstract class ImageSelectionStates extends Equatable {
  const ImageSelectionStates();

  @override
  List<Object> get props => [];
}

class ImageNotSelected extends ImageSelectionStates {}

class ImageSelected extends ImageSelectionStates {
  final List<Asset> resultList;
  final String imageUsedFor;
  ImageSelected({@required this.resultList, @required this.imageUsedFor});

  @override
  List<Object> get props => [resultList, imageUsedFor];
}

class EditPostActive extends ImageSelectionStates {
  final Post post;
  EditPostActive({@required this.post});

  @override
  List<Object> get props => [post];
}

class ImageError extends ImageSelectionStates {
  final String error;
  ImageError({@required this.error});

  @override
  List<Object> get props => [error];
}
