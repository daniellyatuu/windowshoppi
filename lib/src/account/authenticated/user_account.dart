import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class UserAccount extends StatefulWidget {
  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageSelectionBloc, ImageSelectionStates>(
      builder: (context, state) {
        if (state is ImageNotSelected) {
          return PostView();
        } else if (state is ImageSelected) {
          return BlocProvider<CreatePostBloc>(
            create: (context) => CreatePostBloc(),
            child: PostCreate(),
          );
        } else {
          return Container(
            child: Center(
              child: Text('herer error'),
            ),
          );
        }
      },
    );
  }
}
