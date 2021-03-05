import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/app/search/search_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class SearchViewInit extends StatelessWidget {
  final SearchPostRepository searchPostRepository = SearchPostRepository(
    searchPostAPIClient: SearchPostAPIClient(),
  );

  final SearchAccountRepository searchAccountRepository =
      SearchAccountRepository(
    searchAccountAPIClient: SearchAccountAPIClient(),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchTextFieldBloc>(
          create: (context) => SearchTextFieldBloc(),
        ),
        BlocProvider<SearchPostBloc>(
          create: (context) =>
              SearchPostBloc(searchPostRepository: searchPostRepository),
        ),
        BlocProvider<SearchAccountBloc>(
          create: (context) => SearchAccountBloc(
              searchAccountRepository: searchAccountRepository),
        ),
      ],
      child: SearchView(),
    );
  }
}
