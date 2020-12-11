import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

      if (maxScroll - currentScroll <= _scrollThreshold) {
        BlocProvider.of<UserPostBloc>(context)
          ..add(UserPostFetched(accountId: this.widget.accountId));
      }
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
          print(data.length);

          if (state.posts.isEmpty) {
            return Center(
              child: Text(
                'No Posts',
                style: Theme.of(context).textTheme.headline6,
              ),
            );
          }
          return ListView(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {},
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        // data[index].productPhoto[0].filename
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
                                color: Colors.black.withOpacity(0.5),
                              ),
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                '${data[index].productPhoto.toList().length - 1}+',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              if (!state.hasReachedMax) BottomLoader(),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
