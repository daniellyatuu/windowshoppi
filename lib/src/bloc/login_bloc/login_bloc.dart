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
      final userData = await loginRepository.userLogin(event.data);
      print('inside bloc $userData');
      if (userData == 'invalid_account') {
        yield InvalidAccount();
      } else if (userData == 'success') {
        yield ValidAccount();
      }
    }
  }
}
