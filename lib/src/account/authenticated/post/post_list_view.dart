import 'package:windowshoppi/src/utilities/expandable_text.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class PostListView extends StatefulWidget {
  final ScrollController _primaryScrollController;
  final int accountId;

  PostListView(this._primaryScrollController, this.accountId);

  @override
  _PostListViewState createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  final _scrollThreshold = 300.0;

  bool _showLoadMoreIndicator = false;
  bool _showFailedToLoadMore = false;

  void _scrollListener() {
    if (context != null) {
      final maxScroll = this
          .widget
          ._primaryScrollController
          // ignore: invalid_use_of_protected_member
          .positions
          .elementAt(0)
          .maxScrollExtent;
      final currentScroll =
          // ignore: invalid_use_of_protected_member
          this.widget._primaryScrollController.positions.elementAt(0).pixels;

      if (maxScroll - currentScroll <= _scrollThreshold && currentScroll > 0) {
        BlocProvider.of<UserPostBloc>(context)
          ..add(UserPostFetched(accountId: this.widget.accountId));
      }
    }
  }

  Future<void> refresh() async {
    BlocProvider.of<UserPostBloc>(context)
      ..add(UserPostRefresh(accountId: this.widget.accountId));
    await Future.delayed(Duration(milliseconds: 700));
  }

  void _toastNotification(
      String txt, Color color, Toast length, ToastGravity gravity) {
    // close active toast if any before open new one
    Fluttertoast.cancel();

    Fluttertoast.showToast(
        msg: '$txt',
        toastLength: length,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  void _scrollOnTop() async {
    if (widget._primaryScrollController.hasClients) {
      await widget._primaryScrollController.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  void initState() {
    super.initState();
    this.widget._primaryScrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserPostBloc, UserPostStates>(
      listener: (context, state) {
        if (state is UserPostInitNoInternet) {
          _toastNotification('No internet connection', Colors.red,
              Toast.LENGTH_SHORT, ToastGravity.CENTER);
        } else if (state is InvalidToken) {
          BlocProvider.of<AuthenticationBloc>(context)..add(DeleteToken());
        } else if (state is UserPostSuccess) {
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
        if (state is UserPostInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is UserPostInitNoInternet) {
          return GestureDetector(
            onTap: () {
              BlocProvider.of<UserPostBloc>(context)
                ..add(UserPostRefresh(accountId: this.widget.accountId));
            },
            child: NoInternet2(),
          );
        } else if (state is UserPostFailure) {
          return GestureDetector(
            onTap: () {
              BlocProvider.of<UserPostBloc>(context)
                ..add(UserPostRefresh(accountId: this.widget.accountId));
            },
            child: FailedToFetchPost(),
          );
        } else if (state is UserPostSuccess) {
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
                if (state is IndexThreeScrollToTop) _scrollOnTop();
              },
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          PostHeader(
                            post: data[index],
                            from: 'post_list',
                          ),
                          if (data[index].group == 'vendor')
                            if (data[index].businessBio != '')
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.all(5.0),
                                color: Colors.black87,
                                child: ExpandableText(
                                  text: '${data[index].businessBio}',
                                  widgetColor: Colors.white,
                                  textBold: true,
                                  trimLines: 2,
                                  readMore: false,
                                  readLess: false,
                                ),
                              ),
                          PostImage(
                            postImage: data[index].productPhoto,
                          ),
                          AccountPostCaption(
                            post: data[index],
                          ),
                          Divider(),
                        ],
                      );
                    },
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
                          BlocProvider.of<UserPostBloc>(context)
                            ..add(UserPostFetched(
                                accountId: this.widget.accountId));
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
    );
  }
}
