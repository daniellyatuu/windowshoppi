import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/app/search/search_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class SearchViewInit extends StatelessWidget {
  // final SearchPostRepository searchPostRepository = SearchPostRepository(
  //   searchPostAPIClient: SearchPostAPIClient(),
  // );
  //
  // final SearchAccountRepository searchAccountRepository =
  //     SearchAccountRepository(
  //   searchAccountAPIClient: SearchAccountAPIClient(),
  // );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
      builder: (context, state) {
        if (state is IsNotAuthenticated) {
          return SearchView();
          return MultiBlocProvider(
            providers: [
              // BlocProvider<SearchPostBloc>(
              //   create: (context) =>
              //       SearchPostBloc(searchPostRepository: searchPostRepository),
              // ),
              // BlocProvider<SearchAccountBloc>(
              //   create: (context) => SearchAccountBloc(
              //       searchAccountRepository: searchAccountRepository),
              // ),
            ],
            child: SearchView(),
          );
        } else if (state is IsAuthenticated) {
          return SearchView();
          return MultiBlocProvider(
            providers: [
              // BlocProvider<SearchPostBloc>(
              //   create: (context) =>
              //       SearchPostBloc(searchPostRepository: searchPostRepository),
              // ),
              // BlocProvider<SearchAccountBloc>(
              //   create: (context) => SearchAccountBloc(
              //       searchAccountRepository: searchAccountRepository),
              // ),
            ],
            child: SearchView(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
