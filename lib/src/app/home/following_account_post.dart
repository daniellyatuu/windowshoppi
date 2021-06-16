import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/app/home/home_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

class FollowingAccountPost extends StatefulWidget {
  final ScrollController primaryScrollController;
  final String tabName;
  final int accountId;

  FollowingAccountPost(
      {Key key,
      @required this.primaryScrollController,
      @required this.tabName,
      @required this.accountId})
      : super(key: key);

  @override
  _FollowingAccountPostState createState() => _FollowingAccountPostState();
}

class _FollowingAccountPostState extends State<FollowingAccountPost> {
  final _scrollThreshold = 400.0;

  bool _showLoadMoreIndicator = false;
  bool _showFailedToLoadMore = false;

  void _scrollListener() {
    if (mounted) {
      final maxScroll = this
          .widget
          .primaryScrollController
          // ignore: invalid_use_of_protected_member
          .positions
          .elementAt(0)
          .maxScrollExtent;
      final currentScroll =
          // ignore: invalid_use_of_protected_member
          this.widget.primaryScrollController.positions.elementAt(0).pixels;

      if ((maxScroll - currentScroll <= _scrollThreshold) &&
          (currentScroll > 0)) {
        print('load more data');

        // BlocProvider.of<AuthPostBloc>(context)..add(AuthPostLoadMore());
      }
    }
  }

  Future<void> refresh() async {
    // BlocProvider.of<AuthPostBloc>(context)
    //   ..add(AuthPostRefresh(accountId: widget.accountId));
    await Future.delayed(Duration(milliseconds: 700));
  }

  void _scrollToTop() async {
    if (this.widget.primaryScrollController.hasClients) {
      await this.widget.primaryScrollController.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  void initState() {
    super.initState();
    this.widget.primaryScrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: BlocBuilder<AuthenticationBloc, AuthenticationStates>(
        builder: (context, authState) {
          return BlocConsumer<FollowingPostBloc, FollowingPostStates>(
            listener: (context, state) {
              if (state is FollowingPostSuccess) {
                if (state.hasFailedToLoadMore) {
                  setState(() {
                    _showFailedToLoadMore = true;
                  });
                }

                if (!state.hasFailedToLoadMore && !state.hasReachedMax) {
                  setState(() {
                    _showFailedToLoadMore = false;
                    _showLoadMoreIndicator = true;
                  });
                }

                if ((!state.hasFailedToLoadMore && state.hasReachedMax) ||
                    (state.hasFailedToLoadMore && !state.hasReachedMax)) {
                  setState(() {
                    _showLoadMoreIndicator = false;
                  });
                }
              }
            },
            builder: (context, state) {
              if (state is FollowingPostInitFetchLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is FollowingPostNoInternet) {
                return GestureDetector(
                  onTap: () {
                    if (authState is IsAuthenticated) {
                      BlocProvider.of<AuthPostBloc>(context)
                        ..add(AuthPostRefresh(
                            accountId: authState.user.accountId));
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: NoInternet(),
                  ),
                );
              } else if (state is FollowingPostFailure) {
                return GestureDetector(
                  onTap: () {
                    if (authState is IsAuthenticated) {
                      BlocProvider.of<AuthPostBloc>(context)
                        ..add(AuthPostRefresh(
                            accountId: authState.user.accountId));
                    }
                  },
                  child: FailedToFetchPost(),
                );
              } else if (state is FollowingPostSuccess) {
                var data = state.posts;

                if (data.isEmpty) {
                  return Center(
                    child: Text(
                      'No Posts',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: refresh,
                  child: BlocListener<FollowUnfollowBloc, FollowUnfollowStates>(
                    listener: (context, followUnfollowState) {
                      if (followUnfollowState is FollowSuccess) {
                        // BlocProvider.of<AccountInfoBloc>(context)
                        //   ..add(IncrementFollowing());
                      } else if (followUnfollowState is UnfollowSuccess) {
                        // BlocProvider.of<AccountInfoBloc>(context)
                        //   ..add(DecrementFollowing());
                      }
                    },
                    child: BlocListener<DeletePostBloc, DeletePostStates>(
                      listener: (context, deleteState) {
                        if (deleteState is DeletePostSuccess) {
                          // Decrement Added Post
                          BlocProvider.of<AccountInfoBloc>(context)
                            ..add(DecrementPostNo());
                        }
                      },
                      child: ListView(
                        key: PageStorageKey<String>(widget.tabName),
                        padding: EdgeInsets.zero,
                        physics: BouncingScrollPhysics(),
                        children: [
                          SinglePost(
                            tabName: widget.tabName,
                            data: data,
                            from: 'following_tab',
                          ),
                          if (_showLoadMoreIndicator ||
                              !state.hasFailedToLoadMore &&
                                  !state.hasReachedMax)
                            BottomLoader(),
                          if (_showFailedToLoadMore ||
                              state.hasFailedToLoadMore)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    _showLoadMoreIndicator = true;
                                    _showFailedToLoadMore = false;
                                  });
                                  BlocProvider.of<AllPostBloc>(context)
                                    ..add(AllPostFetched());
                                },
                                child: Text(
                                  "Couldn't load posts.Tap to try again",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}
