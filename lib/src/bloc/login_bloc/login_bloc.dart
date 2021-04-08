import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';

class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  final LoginRepository loginRepository;
  LoginBloc({@required this.loginRepository})
      : assert(loginRepository != null),
        super(LoginFormEmpty());

  @override
  Stream<LoginStates> mapEventToState(LoginEvents event) async* {
    if (event is UserLogin) {
      yield LoginFormSubmitting();

      try {
        final _user = await loginRepository.userLogin(event.data);

        if (_user == 'invalid_account') {
          yield InvalidAccount();
        } else if (_user == 'no_internet') {
          yield LoginNoInternet();
        } else if (_user is User) {
          final User user = _user;
          yield ValidAccount(user: user);
        }
      } catch (_) {
        print('error $_');
        yield LoginFormError();
      }
    }
  }
}
