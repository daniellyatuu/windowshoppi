import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

class PostGridView extends StatefulWidget {
  final ScrollController _primaryScrollController;
  final int accountId;

  PostGridView(this._primaryScrollController, this.accountId);

  @override
  _PostGridViewState createState() => _PostGridViewState();
}

class _PostGridViewState extends State<PostGridView> {
  final _scrollThreshold = 200.0;

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

  void _notification(String txt, Color bgColor, Color btnColor) {
    // close active snackBar if any before open new one
    Scaffold.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Text(txt),
      backgroundColor: bgColor,
      action: SnackBarAction(
        label: 'Hide',
        textColor: btnColor,
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
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
                  GridView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      if (data[index].productPhoto.length > 0) {
                        return GestureDetector(
                          onTap: () async {
                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostDetail(post: data[index]),
                              ),
                            );
                            if (result == 'post_deleted_successfully') {
                              BlocProvider.of<UserPostBloc>(context)
                                ..add(UserPostRemove(post: data[index]));
                              _notification('Post deleted successfully.',
                                  Colors.teal, Colors.black);
                            } else if (result == 'edit_post') {
                              BlocProvider.of<ImageSelectionBloc>(context)
                                ..add(EditPost(post: data[index]));
                            }
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              ExtendedImage.network(
                                '${data[index].productPhoto[0].filename}',
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
                              if (data[index].productPhoto.toList().length != 1)
                                Positioned(
                                  top: 6.0,
                                  right: 6.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      '${data[index].productPhoto.toList().length - 1}+',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: Text(
                              'Error Occurred',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      }
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
