import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

class PostInit extends StatelessWidget {
  final UserPostRepository userPostRepository = UserPostRepository(
    userPostAPIClient: UserPostAPIClient(),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
      builder: (context, state) {
        if (state is IsAuthenticated) {
          return BlocProvider<UserPostBloc>(
            create: (context) =>
                UserPostBloc(userPostRepository: userPostRepository)
                  ..add(UserPostFetched(accountId: state.user.accountId)),
            child: PostView(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
