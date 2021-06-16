import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/model/model_files.dart';

class OtherAccountProfile extends StatelessWidget {
  final Post post;
  OtherAccountProfile({@required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            shape: BoxShape.circle,
          ),
          child: post.accountProfile == null
              ? FittedBox(
                  child: Icon(Icons.account_circle, color: Colors.white),
                )
              : ClipOval(
                  child: ExtendedImage.network(
                    '${post.accountProfile}',
                    cache: true,
                    loadStateChanged: (ExtendedImageState state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.loading:
                          return FittedBox(
                            child: Icon(
                              Icons.account_circle,
                              color: Colors.white,
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
                            child: FittedBox(
                              child: Icon(
                                Icons.account_circle,
                                color: Colors.white,
                              ),
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
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${post.username}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              if (post.taggedLocation != null)
                Text(
                  '${post.taggedLocation}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.0),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
