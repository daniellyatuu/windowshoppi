import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvents, AuthenticationStates> {
  final AuthenticationRepository authenticationRepository;
  AuthenticationBloc({@required this.authenticationRepository})
      : assert(authenticationRepository != null),
        super(AuthenticationLoading());

  @override
  Stream<AuthenticationStates> mapEventToState(
      AuthenticationEvents event) async* {
    yield AuthenticationLoading();

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    if (event is CheckUserLoggedInStatus) {
      var token = localStorage.getString('token');
      bool isRegistered = localStorage.getBool('isRegistered') ?? false;

      if (token != null) {
        // get user data
        final User user = await authenticationRepository.getUser(token);
        yield IsAuthenticated(user: user, isLoggedIn: false);
      } else {
        yield IsNotAuthenticated(
            isAlreadyCreateAccount: isRegistered, logout: false);
      }
    } else if (event is UserLoggedIn) {
      // GET USER DATA FOR TEMPORARY .START
      var token = localStorage.getString('token');
      final User user = await authenticationRepository.getUser(token);
      // GET USER DATA FOR TEMPORARY .END

      yield IsAuthenticated(user: user, isLoggedIn: true);
    } else if (event is UserLoggedOut) {
      bool isRegistered = localStorage.getBool('isRegistered') ?? false;
      localStorage.remove('token');

      yield IsNotAuthenticated(
          isAlreadyCreateAccount: isRegistered, logout: true);
    }
  }
}
