import 'package:windowshoppi/src/widget/widget_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/home/home_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 400.0;

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (_scrollThreshold >= maxScroll - currentScroll) {
      BlocProvider.of<AllPostBloc>(context)..add(AllPostFetched());
    }
  }

  Future<void> refresh() async {
    BlocProvider.of<AllPostBloc>(context)..add(AllPostRefresh());
    await Future.delayed(Duration(milliseconds: 700));
  }

  bool _showLoadMoreIndicator = false;
  bool _showFailedToLoadMore = false;

  void _scrollOnTop() async {
    if (_scrollController.hasClients) {
      await _scrollController.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('windowshoppi'),
      ),
      body: BlocConsumer<AllPostBloc, AllPostStates>(
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
          } else if (state is AllPostFailure) {
            return GestureDetector(
              onTap: () {
                BlocProvider.of<AllPostBloc>(context)..add(AllPostRefresh());
              },
              child: FailedToFetchPost(),
            );
          } else if (state is AllPostSuccess) {
            var data = state.posts;

            if (state.posts.isEmpty) {
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
                  if (state is IndexZeroScrollToTop) _scrollOnTop();
                },
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  children: [
                    SinglePost(
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
