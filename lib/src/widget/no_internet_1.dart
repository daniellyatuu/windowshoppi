import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class NoInternet1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<AuthenticationBloc>(context)
            .add(CheckUserLoggedInStatus());
      },
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_cellular_connected_no_internet_4_bar_outlined,
              color: Colors.grey[700],
              size: 90,
            ),
            Text(
              'No internet.Tap to try again',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
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
