import 'package:equatable/equatable.dart';

abstract class UserEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchUserData extends UserEvents {}
