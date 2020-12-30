import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountDetailBloc, AccountDetailStates>(
      builder: (context, state) {
        if (state is AccountDetailLoading) {
          return AccountLoader();
        } else if (state is AccountNotFound) {
          return AccountPageNotFound();
        } else if (state is AccountDetailSuccess) {
          var data = state.account;
          return Scaffold(
            appBar: AppBar(
              title: Text("${data.username}"),
              centerTitle: true,
            ),
            body: AccountPostListInit(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
