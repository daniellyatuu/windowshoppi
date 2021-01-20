import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class CreatePostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class CreatePost extends CreatePostEvents {
  final int accountId;
  final String caption;
  final String location;
  final String lat;
  final String long;
  final String url;
  final String urlText;
  final List<Asset> resultList;
  CreatePost({
    @required this.accountId,
    @required this.caption,
    @required this.location,
    @required this.lat,
    @required this.long,
    @required this.url,
    @required this.urlText,
    @required this.resultList,
  });

  @override
  List<Object> get props => [caption, resultList];
}
