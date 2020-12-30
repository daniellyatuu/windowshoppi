import 'package:windowshoppi/src/account/not_authenticated/account_page_init.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:windowshoppi/src/account/not_authenticated/post/detail.dart';
import 'package:windowshoppi/src/utilities/expandable_text.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:extended_image/extended_image.dart';
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
                  if (state is IndexZeroScrollToTop) _scrollOnTop();
                },
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  children: [
                    Container(
                      child: StaggeredGridView.countBuilder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Detail(
                                                post: data[index],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            if (data[index].group == 'vendor')
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.all(5.0),
                                                color: Colors.black87,
                                                child: ExpandableText(
                                                  text:
                                                      '${data[index].businessBio}',
                                                  widgetColor: Colors.white,
                                                  textBold: true,
                                                  trimLines: 2,
                                                  readMore: false,
                                                  readLess: false,
                                                ),
                                              ),
                                            Expanded(
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: <Widget>[
                                                  ExtendedImage.network(
                                                    '${data[index].productPhoto[0].filename}',
                                                    cache: true,
                                                    loadStateChanged:
                                                        (ExtendedImageState
                                                            state) {
                                                      switch (state
                                                          .extendedImageLoadState) {
                                                        case LoadState.loading:
                                                          return CupertinoActivityIndicator();
                                                          break;

                                                        ///if you don't want override completed widget
                                                        ///please return null or state.completedWidget
                                                        //return null;
                                                        //return state.completedWidget;
                                                        case LoadState
                                                            .completed:
                                                          return ExtendedRawImage(
                                                            fit: BoxFit.cover,
                                                            image: state
                                                                .extendedImageInfo
                                                                ?.image,
                                                          );
                                                          break;
                                                        case LoadState.failed:
                                                          // _controller.reset();
                                                          return GestureDetector(
                                                            child: Center(
                                                              child: Icon(Icons
                                                                  .refresh),
                                                            ),
                                                            onTap: () {
                                                              state
                                                                  .reLoadImage();
                                                            },
                                                          );
                                                          break;
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  if (data[index]
                                                          .productPhoto
                                                          .toList()
                                                          .length !=
                                                      1)
                                                    Positioned(
                                                      top: 3.0,
                                                      right: 3.0,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          color: Colors.black
                                                              .withOpacity(0.3),
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        child: Text(
                                                          '${data[index].productPhoto.toList().length - 1}+',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10.0),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              color: Colors.grey[200],
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.0),
                                              child: ExpandableText(
                                                text: '${data[index].caption}',
                                                trimLines: 2,
                                                readMore: false,
                                                readLess: false,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AccountPageInit(
                                              accountId: data[index].accountId,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5.0),
                                        alignment: Alignment.centerLeft,
                                        color: Colors.grey[200],
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                shape: BoxShape.circle,
                                              ),
                                              child: FittedBox(
                                                child: Icon(
                                                  Icons.account_circle,
                                                  color: Colors.grey[300],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4.0,
                                            ),
                                            Flexible(
                                              child: Text(
                                                '${data[index].username}',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          staggeredTileBuilder: (index) {
                            return StaggeredTile.count(
                                1, index.isEven ? 1.6 : 1.8);
                          }),
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
