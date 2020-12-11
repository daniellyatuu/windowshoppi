import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

abstract class CreatePostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class CreatePost extends CreatePostEvents {
  final int accountId;
  final String caption;
  final List<Asset> resultList;
  CreatePost({
    @required this.accountId,
    @required this.caption,
    @required this.resultList,
  });

  @override
  List<Object> get props => [caption, resultList];
}
