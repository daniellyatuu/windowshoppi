import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DeletePostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class DeletePost extends DeletePostEvents {
  final int postId;
  DeletePost({@required this.postId});

  @override
  List<Object> get props => [postId];
}
