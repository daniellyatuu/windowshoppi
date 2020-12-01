// import 'package:bloc/bloc.dart';
// import 'package:windowshoppi/src/bloc/bloc_files.dart';
// import 'package:windowshoppi/src/repository/repository_files.dart';
// import 'package:windowshoppi/src/model/model_files.dart';
// import 'package:meta/meta.dart';
//
// class UserBloc extends Bloc<UserEvents, UserStates> {
//   final UserRepository userRepository;
//   UserBloc({@required this.userRepository})
//       : assert(userRepository != null),
//         super(UserLoading());
//
//   @override
//   Stream<UserStates> mapEventToState(UserEvents event) async* {
//     if (event is FetchUserData) {
//       yield UserLoading();
//       try {
//         final User user = await userRepository.getUser();
//         print(user.username);
//         print('user result');
//       } catch (error) {
//         print(error);
//         yield UserError();
//       }
//     }
//   }
//
//   //
//   // @override
//   // Stream<CountryStates> mapEventToState(
//   //   CountryEvents event,
//   // ) async* {
//   //   print('step 1 : bloc');
//   //   if (event is FetchCountry) {
//   //     yield CountryLoading();
//   //     try {
//   //       final List<Country> country = await countryRepository.getCountry();
//   //       yield CountryLoaded(country: country);
//   //     } catch (error) {
//   //       print(error);
//   //       yield CountryError();
//   //     }
//   //   }
//   // }
// }
