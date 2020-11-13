import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:http/http.dart' as http;

class UserAccountInit extends StatelessWidget {
  // final UserRepository userRepository = UserRepository(
  //   userAPIClient: UserAPIClient(
  //     httpClient: http.Client(),
  //   ),
  // );

  @override
  Widget build(BuildContext context) {
    return UserAccount();
  }
}
