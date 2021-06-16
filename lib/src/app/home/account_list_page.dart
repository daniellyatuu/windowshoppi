import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:windowshoppi/src/app/home/home_files.dart';
import 'package:windowshoppi/src/bloc/account_list_bloc/account_list_bloc.dart';
import 'package:windowshoppi/src/bloc/account_list_bloc/account_list_events.dart';
import 'package:windowshoppi/src/bloc/account_list_bloc/account_list_states.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

class AccountListPage extends StatefulWidget {
  final ScrollController primaryScrollController;
  final String tabName;

  AccountListPage(
      {@required this.primaryScrollController, @required this.tabName});
  @override
  _AccountListPageState createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  Color _baseColor = Colors.grey[400];

  Color _highlightColor = Colors.grey[200];

  bool _showLoadMoreIndicator = false;
  bool _showFailedToLoadMore = false;

  List<String> imageList = [
    'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW58ZW58MHx8MHw%3D&ixlib=rb-1.2.1&w=1000&q=80',
    'https://cdn.eso.org/images/thumb300y/eso1907a.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuEHrfimWzHnSVc2NXN5uFvpMqHGuheiskIA&usqp=CAU'
  ];

  final _scrollThreshold = 400.0;

  void _scrollListener() {
    if (mounted) {
      print('page 1 here');
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
        BlocProvider.of<AccountListBloc>(context)..add(AccountLoadMore());
      }
    }
  }

  Future<void> refresh() async {
    print('refresh account list');
    // BlocProvider.of<AllPostBloc>(context)..add(AllPostRefresh());
    await Future.delayed(Duration(milliseconds: 700));
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
      child: BlocConsumer<AccountListBloc, AccountListStates>(
        listener: (context, state) {
          if (state is AccountSuccess) {
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
          if (state is AccountInitFetchLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AccountNoInternet) {
            return GestureDetector(
              onTap: () {
                print('retry to fetch account list');
                // BlocProvider.of<AllPostBloc>(context)..add(AllPostRefresh());
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: NoInternet(),
              ),
            );
          } else if (state is AccountFailure) {
            return GestureDetector(
              onTap: () {
                print('retry to fetch accounts');
                // BlocProvider.of<AllPostBloc>(context)..add(AllPostRefresh());
              },
              child: FailedToFetchPost(),
            );
          } else if (state is AccountSuccess) {
            var data = state.accountList;

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
              child: ListView(
                key: PageStorageKey<String>(widget.tabName),
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          'Welcome to Windowshoppi',
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          'Follow people and business to start seeing the photos they share',
                          style: Theme.of(context).textTheme.caption,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'People to Follow',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  AccountList(
                    data: data,
                    tabName: widget.tabName,
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
                          print('refresh fetch more');
                          // BlocProvider.of<AllPostBloc>(context)
                          //   ..add(AllPostFetched());
                        },
                        child: Text(
                          "Couldn't load posts.Tap to try again",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                ],
              ),
              // child: ListView(
              //   key: PageStorageKey<String>(widget.tabName),
              //   padding: EdgeInsets.zero,
              //   physics: BouncingScrollPhysics(),
              //   children: [
              //     // SinglePost(
              //     //   tabName: widget.tabName,
              //     //   data: data,
              //     // ),
              //     // if (_showLoadMoreIndicator ||
              //     //     !state.hasFailedToLoadMore && !state.hasReachedMax)
              //     //   BottomLoader(),
              //     // if (_showFailedToLoadMore || state.hasFailedToLoadMore)
              //     //   Padding(
              //     //     padding: const EdgeInsets.only(bottom: 5.0),
              //     //     child: FlatButton(
              //     //       onPressed: () {
              //     //         setState(() {
              //     //           _showLoadMoreIndicator = true;
              //     //           _showFailedToLoadMore = false;
              //     //         });
              //     //         BlocProvider.of<AllPostBloc>(context)
              //     //           ..add(AllPostFetched());
              //     //       },
              //     //       child: Text(
              //     //         "Couldn't load posts.Tap to try again",
              //     //         style: Theme.of(context).textTheme.bodyText1,
              //     //       ),
              //     //     ),
              //     //   ),
              //   ],
              // ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
