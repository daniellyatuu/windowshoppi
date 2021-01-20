import 'package:windowshoppi/src/utilities/expandable_text.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        if (state is InvalidToken) {
          BlocProvider.of<AuthenticationBloc>(context)..add(DeleteToken());
        }
      },
      builder: (context, state) {
        if (state is UserPostInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is UserPostFailure) {
          return Center(
            child: Text(
              'Failed to fetch posts',
              style: Theme.of(context).textTheme.bodyText1,
            ),
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
                  if (!state.hasReachedMax) BottomLoader(),
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
