import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAppVisitBloc extends Bloc<UserAppVisitEvents, UserAppVisitStates> {
  UserAppVisitBloc() : super(UserAppVisitInitial());

  @override
  Stream<UserAppVisitStates> mapEventToState(UserAppVisitEvents event) async* {
    if (event is CheckUserAppVisit) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var isFirstTime = localStorage.getBool('first_time');

      if (isFirstTime != null && !isFirstTime) {
        if (isFirstTime != false) localStorage.setBool('first_time', false);
        yield IsNotFirstTime();
      } else {
        localStorage.setBool('first_time', false);
        yield IsFirstTime();
      }
    } else if (event is SurveyFinished) {
      yield IsNotFirstTime();
    }
  }
}
