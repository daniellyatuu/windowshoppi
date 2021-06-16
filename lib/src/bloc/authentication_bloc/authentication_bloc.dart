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
    if (event is UserLoggedIn) {
      yield IsAuthenticated(
          user: event.user,
          notification: 'login',
          isAlertDialogActive: event.isAlertDialogActive);
    }

    if (event is UserUpdated) {
      yield IsAuthenticated(
          user: event.user,
          notification: 'update',
          isAlertDialogActive: event.isAlertDialogActive);
    }

    if (event is UserVisitLoginRegister) {
      yield IsNotAuthenticated(
          isAlreadyCreateAccount: event.redirectTo == 'register' ? false : true,
          logout: false);
    }

    // get token from SharedPreferences
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool isRegistered = localStorage.getBool('isRegistered') ?? false;

    if (event is CheckUserLoggedInStatus) {
      yield AuthenticationLoading();

      var token = localStorage.getString('token');

      if (token != null) {
        try {
          // get user
          final _user = await authenticationRepository.getUser(token);

          if (_user == 'no_internet') {
            yield AuthNoInternet();
          } else if (_user is User) {
            final User user = _user;
            yield IsAuthenticated(
                user: user, isAlertDialogActive: {'status': false});
          }
        } catch (_) {
          /// IF ERROR OCCUR IN AUTHENTICATION, CONSIDER USER NOT LOGGED-IN
          //delete the token
          localStorage.remove('token');

          yield IsNotAuthenticated(
              isAlreadyCreateAccount: isRegistered, logout: false);
        }
      } else {
        yield IsNotAuthenticated(
            isAlreadyCreateAccount: isRegistered, logout: false);
      }
    }
    if (event is UserLoggedOut) {
      localStorage.remove('token');

      yield IsNotAuthenticated(
          isAlreadyCreateAccount: isRegistered, logout: true);
    }
    if (event is DeleteToken) {
      localStorage.remove('token');

      yield IsNotAuthenticated(
          isAlreadyCreateAccount: isRegistered, logout: false);
    }
  }
}
