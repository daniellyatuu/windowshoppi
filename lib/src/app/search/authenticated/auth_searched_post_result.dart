import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/app/home/home_files.dart';
import 'package:windowshoppi/src/app/search/search_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

class AuthSearchedPostResult extends StatefulWidget {
  final int accountId;
  const AuthSearchedPostResult({Key key, @required this.accountId})
      : super(key: key);

  @override
  _AuthSearchedPostResultState createState() => _AuthSearchedPostResultState();
}

class _AuthSearchedPostResultState extends State<AuthSearchedPostResult> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 400.0;

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (_scrollThreshold >= maxScroll - currentScroll) {
      print('load more ${widget.accountId}');
      BlocProvider.of<AuthSearchPostBloc>(context)
        ..add(AuthSearchPostLoadMore(accountId: widget.accountId));
    }
  }

  void _getKeyword() {
    BlocProvider.of<SearchTextFieldBloc>(context)..add(CheckSearchedKeyword());
  }

  @override
  void initState() {
    _getKeyword();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchTextFieldBloc, SearchTextFieldStates>(
      listener: (context, state) {
        if (state is SearchTextFieldNotEmpty) {
          print('auth search keyword = ${state.keyword}');
          if (state.keyword != '') {
            BlocProvider.of<AuthSearchPostBloc>(context)
              ..add(AuthInitSearchPostFetched(
                  postKeyword: state.keyword, accountId: widget.accountId));
          }
        }
      },
      child: BlocBuilder<AuthSearchPostBloc, AuthSearchPostStates>(
        builder: (context, state) {
          print('auth state $state');
          if (state is AuthSearchPostEmpty) {
            return SearchWelcomeText(txt: 'Search Posts');
          } else if (state is AuthSearchPostInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AuthSearchPostFailure) {
            return Center(
              child: Text(
                'Failed to fetch posts',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );
          } else if (state is AuthSearchPostSuccess) {
            var data = state.posts;

            if (state.posts.isEmpty) {
              return Center(
                child: Text(
                  'No Posts',
                  style: Theme.of(context).textTheme.headline6,
                ),
              );
            }

            return ListView(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              children: [
                SinglePost(
                  tabName: 'search post',
                  data: data,
                  from: 'search_post',
                ),
                if (!state.hasReachedMax) BottomLoader(),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
