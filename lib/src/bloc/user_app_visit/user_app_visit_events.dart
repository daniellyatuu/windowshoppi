import 'package:equatable/equatable.dart';

abstract class UserAppVisitEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckUserAppVisit extends UserAppVisitEvents {}

class SurveyFinished extends UserAppVisitEvents {}
