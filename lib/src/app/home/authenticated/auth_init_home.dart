import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/app/home/home_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class AuthInitHome extends StatelessWidget {
  const AuthInitHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthPostBloc>(
      create: (context) => AuthPostBloc()..add(AuthPostInitFetch()),
      child: AuthHome(),
    );
  }
}
