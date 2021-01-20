import 'package:windowshoppi/src/utilities/expandable_text.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
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
            return FailedToFetchPost();
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
                  if (state is IndexOneScrollToTop) _scrollOnTop();
                },
                child: ListView(
                  controller: _scrollController,
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
                            TopHeader(
                              post: data[index],
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
                            // AccountPostButton(
                            //   post: data[index],
                            // ),
                            AccountPostCaption(
                              post: data[index],
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                    if (_showLoadMoreIndicator) BottomLoader(),
                    if (_showFailedToLoadMore)
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
