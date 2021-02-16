// import 'package:equatable/equatable.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
// import 'package:windowshoppi/src/model/model_files.dart';
//
// abstract class ImageSelectionEvents extends Equatable {
//   @override
//   List<Object> get props => [];
// }
//
// class CheckImage extends ImageSelectionEvents {}
//
// class SelectImage extends ImageSelectionEvents {
//   final List<Asset> resultList;
//   final String imageUsedFor;
//   SelectImage({@required this.resultList, @required this.imageUsedFor});
//
//   @override
//   List<Object> get props => [resultList, imageUsedFor];
// }
//
// class ClearImage extends ImageSelectionEvents {
//   final List<Asset> resultList;
//   ClearImage({@required this.resultList});
//
//   @override
//   List<Object> get props => [resultList];
// }
//
// class ImageSelectionError extends ImageSelectionEvents {
//   final String error;
//   ImageSelectionError({@required this.error});
//
//   @override
//   List<Object> get props => [error];
// }
//
// class EditPost extends ImageSelectionEvents {
//   final Post post;
//   EditPost({@required this.post});
//
//   @override
//   List<Object> get props => [post];
// }
