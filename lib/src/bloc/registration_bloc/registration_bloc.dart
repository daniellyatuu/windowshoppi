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
    print('step 1 : bloc');
    print(event);
    if (event is SaveUserData) {
      yield FormSubmitting();
      final userData = await registrationRepository.registerUser(event.data);
      if (userData == 'user_exists') {
        yield UserExist();
      } else if (userData == 'success') {
        yield FormSubmitted();
      }

      print('after save');
      // try {
      //   final List<Country> country = await countryRepository.getCountry();
      //   yield CountryLoaded(country: country);
      // } catch (error) {
      //   print(error);
      //   yield CountryError();
      // }
    }
  }
}
