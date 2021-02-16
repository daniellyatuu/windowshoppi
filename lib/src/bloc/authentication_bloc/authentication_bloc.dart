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
    } else if (event is UserUpdated) {
      yield IsAuthenticated(
          user: event.user,
          notification: 'update',
          isAlertDialogActive: event.isAlertDialogActive);
    } else if (event is UserVisitLoginRegister) {
      yield IsNotAuthenticated(
          isAlreadyCreateAccount: event.redirectTo == 'register' ? false : true,
          logout: false);
    } else {
      yield AuthenticationLoading();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      bool isRegistered = localStorage.getBool('isRegistered') ?? false;

      if (event is CheckUserLoggedInStatus) {
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
            yield AuthenticationError();
          }
        } else {
          yield IsNotAuthenticated(
              isAlreadyCreateAccount: isRegistered, logout: false);
        }
      } else if (event is UserLoggedOut) {
        localStorage.remove('token');

        yield IsNotAuthenticated(
            isAlreadyCreateAccount: isRegistered, logout: true);
      } else if (event is DeleteToken) {
        localStorage.remove('token');

        yield IsNotAuthenticated(
            isAlreadyCreateAccount: isRegistered, logout: false);
      }
    }
  }
}
