import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class AccountPageInit extends StatelessWidget {
  final int accountId;
  AccountPageInit({@required this.accountId}) : super();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountDetailBloc>(
          create: (context) =>
              AccountDetailBloc()..add(GetAccountDetail(accountId: accountId)),
        ),
      ],
      child: AccountPage(),
    );
  }
}
