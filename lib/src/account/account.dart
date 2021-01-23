import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  void _notification(String txt, Color bgColor, Color btnColor) {
    Scaffold.of(context)
        .hideCurrentSnackBar(); // hide current snackBar if is active before open new one

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

  void _toastNotification(
      String txt, Color color, Toast length, ToastGravity gravity) {
    // close active toast if any before open new one
    Fluttertoast.cancel();

    Fluttertoast.showToast(
        msg: '$txt',
        toastLength: length,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationStates>(
      listener: (context, AuthenticationStates state) {
        if (state is IsAuthenticated) {
          if (state.isAlertDialogActive['status'] == true) {
            // close transparent loader
            for (int x = 0;
                x < state.isAlertDialogActive['activeDialog'];
                x++) {
              Navigator.of(context, rootNavigator: x == 0 ? true : false).pop();
            }
          }

          if (state.notification == 'login') {
            Future.delayed(Duration(milliseconds: 300), () {
              _toastNotification('Welcome to windowshoppi', Colors.black,
                  Toast.LENGTH_LONG, ToastGravity.SNACKBAR);
            });
          }

          if (state.notification == 'update') {
            Future.delayed(Duration(milliseconds: 300), () {
              _notification('update successfully', Colors.teal, Colors.black);
            });
          }
        } else if (state is IsNotAuthenticated) {
          if (state.logout == true) {
            Future.delayed(Duration(milliseconds: 300), () {
              _toastNotification('logout successfully', Colors.teal,
                  Toast.LENGTH_LONG, ToastGravity.SNACKBAR);
            });
          }
        }
      },
      builder: (context, AuthenticationStates state) {
        if (state is AuthenticationLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AuthenticationError) {
          return AuthenticationErrorMessage();
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
