// import 'package:bloc/bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:windowshoppi/bloc/bloc.dart';
// import 'package:windowshoppi/models/models.dart';
// import 'package:meta/meta.dart';
// import 'package:rxdart/rxdart.dart';
//
// class AuthenticationBloc
//     extends Bloc<AuthenticationEvent, AuthenticationStates> {
//   AuthenticationBloc() : super(AuthenticationLoading());
//
//   @override
//   Stream<AuthenticationStates> mapEventToState(
//       AuthenticationEvent event) async* {
//     print('bloc for auth');
//     print(event);
//     if (event is CheckUserLoggedInStatus) {
//       // yield
//
//       SharedPreferences localStorage = await SharedPreferences.getInstance();
//       var token = localStorage.getString('token');
//       if (token != null) {
//         print('yes');
//         yield IsAuthenticated();
//       } else {
//         print('not loggedIn');
//         yield IsNotAuthenticated();
//       }
//       print(token);
//     }
//     // if (event is FetchCountry) {S
//     //   yield CountryLoading();
//     //   try {
//     //     final List<Country> country = await countryRepository.getCountry();
//     //     yield CountryLoaded(country: country);
//     //   } catch (error) {
//     //     print(error);
//     //     yield CountryError();
//     //   }
//     // }
//   }
// }
