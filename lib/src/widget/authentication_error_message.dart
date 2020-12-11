import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class AuthenticationErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          FlatButton(
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(CheckUserLoggedInStatus());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                ),
                Text(
                  "Couldn't load.Tap to try again",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 100,
          // ),
          // FlatButton(
          //   // color: Colors.red,
          //   onPressed: () {
          //     BlocProvider.of<AuthenticationBloc>(context).add(DeleteToken());
          //   },
          //   child: Text(
          //     'click here to login or register again',
          //     style: Theme.of(context).textTheme.caption,
          //   ),
          // ),
        ],
      ),
    );
    // return Center(
    //   child: GestureDetector(
    //     onTap: () {
    //       BlocProvider.of<AuthenticationBloc>(context)
    //           .add(CheckUserLoggedInStatus());
    //     },
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Icon(
    //           Icons.error_outline,
    //         ),
    //         Text(
    //           'Couldn\'t load.Tap to try again',
    //           style: Theme.of(context).textTheme.bodyText1,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
