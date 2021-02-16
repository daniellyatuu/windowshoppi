import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class LoginOrRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: ListView(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: [
                Text(
                  'Please Register or Login to continue',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Divider(),
                Row(
                  children: [
                    Expanded(
                      child: OutlineButton(
                        onPressed: () {
                          // close popup
                          Navigator.of(context).pop();

                          // open account page
                          BlocProvider.of<NavigationBloc>(context)
                            ..add(ChangeIndex(index: 4));

                          // make register page active
                          BlocProvider.of<AuthenticationBloc>(context)
                            ..add(
                                UserVisitLoginRegister(redirectTo: 'register'));
                        },
                        borderSide: BorderSide(color: Colors.teal, width: 2.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            8.0,
                          ),
                        ),
                        child: Text('Register'),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: OutlineButton(
                        onPressed: () {
                          // close popup
                          Navigator.of(context).pop();

                          // open account page
                          BlocProvider.of<NavigationBloc>(context)
                            ..add(ChangeIndex(index: 4));

                          // make register page active
                          BlocProvider.of<AuthenticationBloc>(context)
                            ..add(UserVisitLoginRegister(redirectTo: 'login'));
                        },
                        borderSide: BorderSide(color: Colors.teal, width: 2.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            8.0,
                          ),
                        ),
                        child: Text('Login'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
