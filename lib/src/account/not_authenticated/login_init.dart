import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

class LoginInit extends StatelessWidget {
  final LoginRepository loginRepository = LoginRepository(
    loginAPIClient: LoginAPIClient(),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(loginRepository: loginRepository),
      child: Login(),
    );
  }
}
