import 'package:windowshoppi/src/bloc/account_post_bloc/account_post_events.dart';
import 'package:windowshoppi/src/bloc/account_post_bloc/account_post_bloc.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class AccountPostListInit extends StatelessWidget {
  final AccountPostRepository accountPostRepository = AccountPostRepository(
    accountPostAPIClient: AccountPostAPIClient(),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountDetailBloc, AccountDetailStates>(
      builder: (context, state) {
        if (state is AccountDetailSuccess) {
          return BlocProvider<AccountPostBloc>(
            create: (context) =>
                AccountPostBloc(accountPostRepository: accountPostRepository)
                  ..add(AccountPostFetched(accountId: state.account.accountId)),
            child: AccountPostList(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
