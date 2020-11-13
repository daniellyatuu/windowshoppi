// import 'package:bloc/bloc.dart';
// import 'package:flutter/foundation.dart';
// import 'package:windowshoppi/bloc/bloc.dart';
// // import 'package:windowshoppi/repository/country_repository/CountryRepository.dart';
// import 'package:windowshoppi/repository/repository.dart';
// // import 'package:windowshoppi/models/models.dart';
// // import 'package:meta/meta.dart';
// // import 'package:rxdart/rxdart.dart';
//
// class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationStates> {
//   final RegistrationRepository registrationRepository;
//   RegistrationBloc({@required this.registrationRepository})
//       : assert(registrationRepository != null),
//         super(FormEmpty());
//
//   @override
//   Stream<RegistrationStates> mapEventToState(RegistrationEvent event) async* {
//     print('step 1 : bloc');
//     print(event);
//     if (event is SaveUserData) {
//       yield FormSubmitting();
//       final userData = await registrationRepository.registerUser(event.data);
//       if (userData == 'user_exists') {
//         yield UserExist();
//       } else if (userData == 'success') {
//         yield FormSubmitted();
//       }
//
//       print('after save');
//       // try {
//       //   final List<Country> country = await countryRepository.getCountry();
//       //   yield CountryLoaded(country: country);
//       // } catch (error) {
//       //   print(error);
//       //   yield CountryError();
//       // }
//     }
//   }
// }
