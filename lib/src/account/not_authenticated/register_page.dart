import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  final CountryRepository countryRepository = CountryRepository(
    countryAPIClient: CountryAPIClient(
      httpClient: http.Client(),
    ),
  );

  final RegistrationRepository registrationRepository = RegistrationRepository(
    registrationAPIClient: RegistrationAPIClient(),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CountryBloc>(
          create: (context) => CountryBloc(countryRepository: countryRepository)
            ..add(FetchCountry()),
        ),
        BlocProvider<RegistrationBloc>(
          create: (context) =>
              RegistrationBloc(registrationRepository: registrationRepository),
        ),
      ],
      child: RegisterForm(),
    );
  }
}
