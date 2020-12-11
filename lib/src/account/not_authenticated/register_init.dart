import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class RegisterInit extends StatelessWidget {
  final RegistrationRepository registrationRepository = RegistrationRepository(
    registrationAPIClient: RegistrationAPIClient(),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegistrationBloc>(
          create: (context) =>
              RegistrationBloc(registrationRepository: registrationRepository),
        ),
      ],
      child: RegisterForm(),
    );
  }
}
