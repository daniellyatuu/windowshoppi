import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/account/account_files.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationStates>(
      listener: (context, AuthenticationStates state) {
        print(state);
      },
      builder: (context, AuthenticationStates state) {
        if (state is AuthenticationLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is IsAuthenticated) {
          return UserAccountInit();
        } else if (state is IsNotAuthenticated) {
          return LoginRegister();
        } else {
          return Text('');
        }
      },
    );
  }
}
