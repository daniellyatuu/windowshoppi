import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class UpdatePostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdatePost extends UpdatePostEvents {
  final int postId;
  final dynamic data;

  UpdatePost({@required this.postId, @required this.data});

  @override
  List<Object> get props => [postId, data];
}
