import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:bloc/bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvents, AuthenticationStates> {
  AuthenticationBloc() : super(AuthenticationLoading());

  @override
  Stream<AuthenticationStates> mapEventToState(
      AuthenticationEvents event) async* {
    yield AuthenticationLoading();
    if (event is CheckUserLoggedInStatus) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var token = localStorage.getString('token');
      if (token != null) {
        yield IsAuthenticated();
      } else {
        yield IsNotAuthenticated();
      }
    } else if (event is UserLoggedIn) {
      yield IsAuthenticated();
    } else if (event is UserLoggedOut) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('token');
      yield IsNotAuthenticated();
    }
  }
}
