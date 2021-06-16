import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/app/home/home_files.dart';
import 'package:windowshoppi/src/app/info/info_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  ScrollController _controller;

  final _scrollThreshold = 100.0;

  bool _showLoadMoreIndicator = false;
  bool _showFailedToLoadMore = false;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;

    if (maxScroll - currentScroll <= _scrollThreshold) {
      // BlocProvider.of<ProductCategoryBloc>(context)
      //   ..add(LoadMoreProductCategory());
    }
  }

  Future<void> _refresh(BuildContext context) async {
    print('refresh');
    // BlocProvider.of<ProductCategoryBloc>(context)
    //   ..add(ProductCategoryRefresh());
    await Future.delayed(Duration(milliseconds: 700));
    // return fetchFruit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity'),
      ),
      body: BlocConsumer<NotificationBloc, NotificationStates>(
        listener: (context, state) {
          if (state is NotificationSuccess) {
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
          if (state is NotificationFetchLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is NotificationNoInternet) {
            return GestureDetector(
              onTap: () {
                // BlocProvider.of<ProductCategoryBloc>(context)
                //   ..add(InitFetchProductCategory());
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: NoInternet(),
              ),
            );
          } else if (state is NotificationFailure) {
            return GestureDetector(
              onTap: () {
                // BlocProvider.of<ProductCategoryBloc>(context)
                //   ..add(InitFetchProductCategory());
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: Colors.grey[700],
                          size: 40,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'Failed to fetch notifications.Tap to try again',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (state is NotificationSuccess) {
            var data = state.notifications;

            if (data.isEmpty) {
              return Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'No Notifications',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: ListView(
                controller: _controller,
                key: PageStorageKey<String>('notifications'),
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                children: [
                  InfoList(data: data),
                  if (_showLoadMoreIndicator ||
                      !state.hasFailedToLoadMore && !state.hasReachedMax)
                    BottomLoader(),
                  if (_showFailedToLoadMore || state.hasFailedToLoadMore)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _showLoadMoreIndicator = true;
                            _showFailedToLoadMore = false;
                          });
                          // BlocProvider.of<ProductCategoryBloc>(context)
                          //   ..add(LoadMoreProductCategory());
                        },
                        child: Text(
                          "Couldn't load notifications, Tap to try again.",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                ],
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
