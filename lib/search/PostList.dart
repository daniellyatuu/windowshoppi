import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:windowshoppi/bloc/bloc.dart';
import 'package:windowshoppi/widgets/loader.dart';

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 400.0;

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    print(maxScroll - currentScroll);
    if (_scrollThreshold >= maxScroll - currentScroll) {
      // final bloc = Provider.of<SearchKeywordBloc>(context);
      // bloc.searchedKeyword.listen(
      //   (event) {
      //     print('more search data for = ' + event);
      //   },
      // );
      // BlocProvider.of<PostBloc>(context).add(FetchPosts(keyword: 'tv'));
    }
  }

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(_onScroll);
    return BlocConsumer<PostBloc, PostStates>(
      listener: (context, PostStates state) {
        if (state is PostLoaded) {
          // print('Im here');
        }
      },
      builder: (context, PostStates state) {
        if (state is PostEmpty) {
          return PostBody();
        } else if (state is PostLoading) {
          return Container(
            child: StaggeredGridView.countBuilder(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return BottomLoader();
                },
                staggeredTileBuilder: (index) {
                  return StaggeredTile.count(1, index.isEven ? 1.0 : 1.3);
                }),
          );
          // return Container(
          //   padding: EdgeInsets.only(top: 20.0),
          //   alignment: Alignment.topCenter,
          //   child: CircularProgressIndicator(),
          // );
        } else if (state is PostLoaded) {
          final posts = state.post;

          if (posts.isEmpty) {
            return Container(
              padding: EdgeInsets.only(top: 20.0),
              alignment: Alignment.topCenter,
              child: Text('No posts'),
            );
          }

          return Container(
            child: StaggeredGridView.countBuilder(
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                crossAxisCount: 2,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   FadeRoute(
                          //     widget: Details(
                          //         loggedInBussinessId:
                          //         loggedInBussinessId,
                          //         singlePost:
                          //         products[index]),
                          //   ),
                          // );
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            ExtendedImage.network(
                              posts[index].productPhoto[0].filename,
                              cache: true,
                              loadStateChanged: (ExtendedImageState state) {
                                switch (state.extendedImageLoadState) {
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
                                      image: state.extendedImageInfo?.image,
                                    );
                                    break;
                                  case LoadState.failed:
                                    // _controller.reset();
                                    return GestureDetector(
                                      child: Center(
                                        child: Icon(Icons.refresh),
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
                            if (posts[index].productPhoto.toList().length != 1)
                              Positioned(
                                top: 6.0,
                                right: 6.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    '${posts[index].productPhoto.toList().length - 1}+',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
//
                    ),
                  );
                  // if (index < posts.length) {
                  //
                  //   // } else if (allProducts - data.length > 0) {
                  // } else {
                  //   return BottomLoader();
                  // }
                },
                staggeredTileBuilder: (index) {
                  return StaggeredTile.count(1, index.isEven ? 1.0 : 1.3);
                }),
          );
        }
        return Text('');
      },
    );
  }
}

class PostBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SearchKeywordBloc>(context);
    bloc.searchedKeyword.listen(
      (event) {
        // print('result in post = ' + event);
      },
    );
    return Center(
      child: ListView(
        children: [
          StreamBuilder<Object>(
            stream: bloc.searchedKeyword,
            builder: (context, snapshot) {
              return Text(snapshot.data ?? '');
            },
          ),
          RaisedButton(
            onPressed: () {
              BlocProvider.of<PostBloc>(context)
                  .add(FetchPosts(keyword: 'Los Angeles'));
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
