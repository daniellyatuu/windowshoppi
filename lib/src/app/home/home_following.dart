import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:extended_image/extended_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

class HomeFollowing extends StatefulWidget {
  final ScrollController primaryScrollController;
  final String tabName;

  HomeFollowing(
      {@required this.primaryScrollController, @required this.tabName});
  @override
  _HomeFollowingState createState() => _HomeFollowingState();
}

class _HomeFollowingState extends State<HomeFollowing> {
  Color _baseColor = Colors.grey[400];

  Color _highlightColor = Colors.grey[200];

  List<String> imageList = [
    'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW58ZW58MHx8MHw%3D&ixlib=rb-1.2.1&w=1000&q=80',
    'https://cdn.eso.org/images/thumb300y/eso1907a.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuEHrfimWzHnSVc2NXN5uFvpMqHGuheiskIA&usqp=CAU'
  ];

  final _scrollThreshold = 400.0;

  void _scrollListener() {
    if (context != null) {
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

      print('page 1 maxScroll $maxScroll');
      print('page 1 currentScroll $currentScroll');
      if ((maxScroll - currentScroll <= _scrollThreshold) &&
          (currentScroll > 0)) {
        print('load more following posts');
        // BlocProvider.of<UserPostBloc>(context)
        //   ..add(UserPostFetched(accountId: this.widget.accountId));
      }
    }
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
      child: ListView(
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
          ListView.separated(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: 10,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              // return PeopleToFollowLoader();
              return GestureDetector(
                onTap: () {
                  print('view account');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Username in here',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(
                                  'account name',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              print('follow account');
                            },
                            child: Text('Follow'),
                            shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 6,
                            height: MediaQuery.of(context).size.width / 6,
                            child: ClipOval(
                              child: ExtendedImage.network(
                                'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW58ZW58MHx8MHw%3D&ixlib=rb-1.2.1&w=1000&q=80',
                                cache: true,
                                loadStateChanged: (ExtendedImageState state) {
                                  switch (state.extendedImageLoadState) {
                                    case LoadState.loading:
                                      return Shimmer.fromColors(
                                        baseColor: _baseColor,
                                        highlightColor: _highlightColor,
                                        child: Container(
                                          color: Colors.red,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              6,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              6,
                                        ),
                                      );

                                      // return CupertinoActivityIndicator();
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
                            ),
                          ),
                          for (String image in imageList)
                            Container(
                              width: MediaQuery.of(context).size.width / 8,
                              height: MediaQuery.of(context).size.width / 8,
                              child: ExtendedImage.network(
                                '$image',
                                cache: true,
                                loadStateChanged: (ExtendedImageState state) {
                                  switch (state.extendedImageLoadState) {
                                    case LoadState.loading:
                                      return Shimmer.fromColors(
                                        baseColor: _baseColor,
                                        highlightColor: _highlightColor,
                                        child: Container(
                                          color: Colors.red,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              6,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              6,
                                        ),
                                      );
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
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    // return SafeArea(
    //   top: false,
    //   bottom: false,
    //   child: ListView.builder(
    //     padding: EdgeInsets.zero,
    //     itemCount: 20,
    //     key: PageStorageKey<String>(widget.tabName),
    //     itemBuilder: (context, index) {
    //       return Column(
    //         children: <Widget>[
    //           Container(
    //             height: 150,
    //             width: double.infinity,
    //             color: Colors.blueGrey,
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: <Widget>[Text('follow $index')],
    //             ),
    //           ),
    //           SizedBox(
    //             height: 8,
    //           )
    //         ],
    //       );
    //     },
    //   ),
    // );
  }
}
