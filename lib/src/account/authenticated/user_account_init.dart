import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:http/http.dart' as http;

class UserAccountInit extends StatelessWidget {
  final UserPostRepository userPostRepository = UserPostRepository(
    userPostAPIClient: UserPostAPIClient(),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserPostBloc>(
      create: (context) => UserPostBloc(userPostRepository: userPostRepository),
      child: UserAccount(),
    );
  }
}
