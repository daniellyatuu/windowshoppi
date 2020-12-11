import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

abstract class ImageSelectionStates extends Equatable {
  const ImageSelectionStates();

  @override
  List<Object> get props => [];
}

class ImageNotSelected extends ImageSelectionStates {}

class ImageSelected extends ImageSelectionStates {
  final List<Asset> resultList;
  ImageSelected({@required this.resultList});

  @override
  List<Object> get props => [resultList];
}

class ImageError extends ImageSelectionStates {
  final String error;
  ImageError({@required this.error});

  @override
  List<Object> get props => [error];
}
