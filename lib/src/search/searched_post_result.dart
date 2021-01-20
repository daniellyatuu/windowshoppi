import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/search/search_files.dart';
import 'package:windowshoppi/src/utilities/expandable_text.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

class SearchedPostResult extends StatefulWidget {
  @override
  _SearchedPostResultState createState() => _SearchedPostResultState();
}

class _SearchedPostResultState extends State<SearchedPostResult> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 400.0;

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (_scrollThreshold >= maxScroll - currentScroll) {
      BlocProvider.of<SearchPostBloc>(context)..add(SearchPostLoadMore());
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
          if (state.keyword != '') {
            BlocProvider.of<SearchPostBloc>(context)
              ..add(InitSearchPostFetched(postKeyword: state.keyword));
          }
        }
      },
      child: BlocBuilder<SearchPostBloc, SearchPostStates>(
        builder: (context, state) {
          if (state is SearchPostEmpty) {
            return SearchWelcomeText(txt: 'Search Posts');
          } else if (state is SearchPostInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SearchPostFailure) {
            return Center(
              child: Text(
                'Failed to fetch posts',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );
          } else if (state is SearchPostSuccess) {
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
                                          ));
                                    },
                                    child: Column(
                                      children: [
                                        if (data[index].group == 'vendor')
                                          if (data[index].businessBio != '')
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
                                                    (ExtendedImageState state) {
                                                  switch (state
                                                      .extendedImageLoadState) {
                                                    case LoadState.loading:
                                                      return CupertinoActivityIndicator();
                                                      break;

                                                    ///if you don't want override completed widget
                                                    ///please return null or state.completedWidget
                                                    //return null;
                                                    //return state.completedWidget;
                                                    case LoadState.completed:
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
                                                          child: Icon(
                                                              Icons.refresh),
                                                        ),
                                                        onTap: () {
                                                          state.reLoadImage();
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
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                    ),
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Text(
                                                      '${data[index].productPhoto.toList().length - 1}+',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                        builder: (context) => AccountPageInit(
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
                                            color: Colors.grey[200],
                                            shape: BoxShape.circle,
                                          ),
                                          child: data[index].accountProfile !=
                                                      null &&
                                                  data[index].accountProfile !=
                                                      ''
                                              ? CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey[200],
                                                  radius: 60.0,
                                                  backgroundImage: NetworkImage(
                                                      '${data[index].accountProfile}'),
                                                )
                                              : FittedBox(
                                                  child: Icon(
                                                      Icons.account_circle,
                                                      color: Colors.grey[400]),
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
                        return StaggeredTile.count(1, index.isEven ? 1.6 : 1.8);
                      }),
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
