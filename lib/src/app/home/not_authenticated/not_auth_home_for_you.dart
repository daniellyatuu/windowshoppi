import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/app/home/home_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

class NotAuthHomeForYou extends StatefulWidget {
  final ScrollController primaryScrollController;
  final String tabName;

  NotAuthHomeForYou(
      {@required this.primaryScrollController, @required this.tabName});

  @override
  _NotAuthHomeForYouState createState() => _NotAuthHomeForYouState();
}

class _NotAuthHomeForYouState extends State<NotAuthHomeForYou> {
  final _scrollThreshold = 100.0;

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
        BlocProvider.of<AllPostBloc>(context)..add(AllPostFetched());
      }
    }
  }

  Future<void> refresh() async {
    BlocProvider.of<AllPostBloc>(context)..add(AllPostRefresh());
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
      child: BlocConsumer<AllPostBloc, AllPostStates>(
        listener: (context, state) {
          if (state is AllPostSuccess) {
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
          if (state is AllPostInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AllPostNoInternet) {
            return GestureDetector(
              onTap: () {
                BlocProvider.of<AllPostBloc>(context)..add(AllPostRefresh());
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: NoInternet(),
              ),
            );
          } else if (state is AllPostFailure) {
            return GestureDetector(
              onTap: () {
                BlocProvider.of<AllPostBloc>(context)..add(AllPostRefresh());
              },
              child: FailedToFetchPost(),
            );
          } else if (state is AllPostSuccess) {
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
              child: BlocListener<ScrollToTopBloc, ScrollToTopStates>(
                listener: (context, state) async {
                  if (state is IndexZeroScrollToTop) _scrollToTop();
                },
                child: ListView(
                  key: PageStorageKey<String>(widget.tabName),
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  children: [
                    SinglePost(
                      tabName: widget.tabName,
                      data: data,
                    ),
                    if (_showLoadMoreIndicator ||
                        !state.hasFailedToLoadMore && !state.hasReachedMax)
                      BottomLoader(),
                    if (_showFailedToLoadMore || state.hasFailedToLoadMore)
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
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
