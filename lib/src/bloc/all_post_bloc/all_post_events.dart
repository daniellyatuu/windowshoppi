import 'package:windowshoppi/src/model/model_files.dart';
import 'package:equatable/equatable.dart';

abstract class AllPostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class AllPostFetched extends AllPostEvents {}

class AllPostRefresh extends AllPostEvents {}

class AllPostInsert extends AllPostEvents {
  final Post post;

  AllPostInsert({this.post});

  @override
  List<Object> get props => [post];
}

class PostRemove extends AllPostEvents {
  final Post post;

  PostRemove({this.post});

  @override
  List<Object> get props => [post];
}

class AllPostRetry extends AllPostEvents {}
