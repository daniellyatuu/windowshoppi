import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';

class SwitchToBusinessInit extends StatelessWidget {
  final User user;
  SwitchToBusinessInit({@required this.user}) : super();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SwitchToBusinessBloc>(
      create: (context) => SwitchToBusinessBloc(),
      child: SwitchToBusinessForm(
        user: user,
      ),
    );
  }
}
