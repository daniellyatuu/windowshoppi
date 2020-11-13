import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/account/account_files.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  void _notification(String txt, Color bgColor, Color btnColor) {
    final snackBar = SnackBar(
      content: Text(txt),
      backgroundColor: bgColor,
      action: SnackBarAction(
        label: 'Hide',
        textColor: btnColor,
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationStates>(
      listener: (context, AuthenticationStates state) {
        if (state is IsAuthenticated) {
          if (state.isLoggedIn == true) {
            Future.delayed(Duration(milliseconds: 300), () {
              _notification(
                  'Welcome to windowshoppi', Colors.black, Colors.red);
            });
          }
        } else if (state is IsNotAuthenticated) {
          if (state.logout == true) {
            Future.delayed(Duration(milliseconds: 300), () {
              _notification('logout successfully', Colors.teal, Colors.black);
            });
          }
        }
      },
      builder: (context, AuthenticationStates state) {
        if (state is AuthenticationLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is IsAuthenticated) {
          return UserAccountInit();
        } else if (state is IsNotAuthenticated) {
          return LoginRegister(registerIsActive: !state.isAlreadyCreateAccount);
        } else {
          return Container();
        }
      },
    );
  }
}
