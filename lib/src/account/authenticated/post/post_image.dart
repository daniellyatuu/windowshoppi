import 'package:carousel_pro/carousel_pro.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostImage extends StatefulWidget {
  final postImage;
  PostImage({@required this.postImage});

  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  int _activePhoto = 1;
  bool _imageCover = true;

  void _changeImageView() {
    setState(() {
      _imageCover = !_imageCover;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.0,
          child: Carousel(
            autoplay: false,
            animationCurve: Curves.fastOutSlowIn,
            dotSize: 4.0,
            dotIncreasedColor: Color(0xFFFF335C),
            dotBgColor: Colors.transparent,
            dotPosition: DotPosition.bottomCenter,
            dotColor: Colors.white,
            dotVerticalPadding: 0.0,
            showIndicator: widget.postImage.toList().length > 1 ? true : false,
            indicatorBgPadding: 8.0,
            onImageChange: (int, activeImage) {
              setState(() {
                _activePhoto = activeImage + 1;
              });
            },
            images: [
              for (var image in widget.postImage)
                ExtendedImage.network(
                  '${image.filename}',
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
            ],
          ),
        ),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: GestureDetector(
            onTap: _changeImageView,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.black.withOpacity(0.3),
              ),
              padding: EdgeInsets.all(5.0),
              child: Icon(
                _imageCover ? Icons.fullscreen_exit : Icons.fullscreen,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
        ),
        if (widget.postImage.toList().length != 1)
          Positioned(
            top: 3.0,
            right: 6.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.black.withOpacity(0.3),
              ),
              padding: EdgeInsets.all(5.0),
              child: Text(
                '$_activePhoto/${widget.postImage.toList().length}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0),
              ),
            ),
          ),
      ],
    );
  }
}
