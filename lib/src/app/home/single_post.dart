import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:windowshoppi/src/utilities/expandable_text.dart';
import 'package:windowshoppi/src/app/explore/explore_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:page_transition/page_transition.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SinglePost extends StatelessWidget {
  final List<Post> data;
  final String tabName;
  SinglePost({@required this.tabName, @required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StaggeredGridView.countBuilder(
          key: PageStorageKey<String>(tabName),
          padding: EdgeInsets.zero,
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
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                child: Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 200),
                              child: Explore(
                                index: index,
                              ),
                            ),
                          );
                          // Navigator.push(
                          //     context,
                          //     SlideFromRightPageRoute(
                          //       widget: Explore(),
                          //     ));
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => Detail(
                          //       post: data[index],
                          //     ),
                          //   ),
                          // );
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
                                    text: '${data[index].businessBio}',
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
                                            image:
                                                state.extendedImageInfo?.image,
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
                                              BorderRadius.circular(5.0),
                                          color: Colors.black.withOpacity(0.3),
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
                                  if (data[index].recommendationName != null)
                                    Positioned(
                                      bottom: 3.0,
                                      left: 3.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.recommend,
                                              color: Colors.white,
                                              size: 18.0,
                                            ),
                                            Container(
                                              constraints: BoxConstraints(
                                                maxWidth:
                                                    (MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            4) +
                                                        ((MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                4) /
                                                            2),
                                              ),
                                              padding:
                                                  EdgeInsets.only(right: 5.0),
                                              child: Text(
                                                " ${data[index].recommendationName}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
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
            return StaggeredTile.count(1, index.isEven ? 1.4 : 1.6);
          }),
    );
  }
}
