import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/explore/explore_files.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';

class ExploreInit extends StatelessWidget {
  final AllPostRepository allPostRepository = AllPostRepository(
    allPostAPIClient: AllPostAPIClient(),
  );
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AllPostBloc>(
      create: (context) => AllPostBloc(allPostRepository: allPostRepository)
        ..add(AllPostFetched()),
      child: Explore(),
    );
  }
}
