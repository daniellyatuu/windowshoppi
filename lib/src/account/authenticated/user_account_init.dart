import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class UserAccountInit extends StatelessWidget {
  final UserPostRepository userPostRepository = UserPostRepository(
    userPostAPIClient: UserPostAPIClient(),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
      builder: (context, state) {
        if (state is IsAuthenticated) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    UserPostBloc(userPostRepository: userPostRepository)
                      ..add(UserPostFetched(accountId: state.user.accountId)),
              ),
              BlocProvider<ImageSelectionBloc>(
                create: (context) => ImageSelectionBloc()..add(CheckImage()),
              ),
            ],
            child: UserAccount(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
