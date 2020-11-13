import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class UserEndDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              BlocProvider.of<AuthenticationBloc>(context).add(UserLoggedOut());
            },
            child: Card(
              child: ListTile(
                dense: true,
                title: Text('LOGOUT'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
