import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';

class RegistrationBloc extends Bloc<RegistrationEvents, RegistrationStates> {
  final RegistrationRepository registrationRepository;
  RegistrationBloc({@required this.registrationRepository})
      : assert(registrationRepository != null),
        super(FormEmpty());

  @override
  Stream<RegistrationStates> mapEventToState(RegistrationEvents event) async* {
    if (event is SaveUserData) {
      yield FormSubmitting();
      try {
        final _user = await registrationRepository.registerUser(event.data);

        if (_user == 'user_exists') {
          yield UserExist();
        } else if (_user is User) {
          final User user = _user;
          yield FormSubmitted(user: user);
        }
      } catch (e) {
        yield FormError(error: e);
      }
    }
  }
}
