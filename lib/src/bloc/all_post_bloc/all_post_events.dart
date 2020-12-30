import 'package:equatable/equatable.dart';

abstract class AllPostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class AllPostFetched extends AllPostEvents {}

class AllPostRefresh extends AllPostEvents {}

class AllPostRetry extends AllPostEvents {}
