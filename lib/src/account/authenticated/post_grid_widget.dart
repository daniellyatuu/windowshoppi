import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/model/model_files.dart';

class PostGridWidget extends StatelessWidget {
  final Post post;
  PostGridWidget({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {},
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ExtendedImage.network(
            post.productPhoto[0].filename,
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
          if (post.productPhoto.toList().length != 1)
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
                  '${post.productPhoto.toList().length - 1}+',
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
  }
}
