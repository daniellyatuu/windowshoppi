import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';

class ImageSection extends StatefulWidget {
  final Function(int) activeImage;
  final postImage;
  ImageSection({Key key, this.postImage, this.activeImage}) : super(key: key);

  @override
  _ImageSectionState createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  bool _imageCover = true;
  int _activePhoto = 1;

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
                widget.activeImage(activeImage);
                _activePhoto = activeImage + 1;
              });
            },
            images: [
              for (var image in widget.postImage)
                CachedNetworkImage(
                  fit: _imageCover ? BoxFit.cover : BoxFit.contain,
                  imageUrl: image.filename,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
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
                color: Colors.black.withOpacity(0.5),
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
            child: GestureDetector(
              onTap: _changeImageView,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.black.withOpacity(0.5),
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
          ),
      ],
    );
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.start,
//      mainAxisSize: MainAxisSize.min,
//      crossAxisAlignment: CrossAxisAlignment.stretch,
//      children: <Widget>[
//        AspectRatio(
//          aspectRatio: 1,
//          child: Carousel(
//            boxFit: BoxFit.cover,
//            autoplay: false,
//            animationCurve: Curves.fastOutSlowIn,
//            dotSize: 4.0,
//            dotIncreasedColor: Color(0xFFFF335C),
//            dotBgColor: Colors.transparent,
//            dotPosition: DotPosition.bottomCenter,
//            dotColor: Colors.black,
//            dotVerticalPadding: 2.0,
//            showIndicator: true,
//            indicatorBgPadding: 5.0,
//            images: [
//              for (var image in widget.postImage)
//                CachedNetworkImage(
//                  fit: BoxFit.cover,
//                  imageUrl: image.filename,
//                  progressIndicatorBuilder: (context, url, downloadProgress) =>
//                      CupertinoActivityIndicator(),
//                  errorWidget: (context, url, error) => Icon(Icons.error),
//                ),
//            ],
//          ),
//        ),
////        Flexible(
////          fit: FlexFit.loose,
////          child: FadeInImage.memoryNetwork(
////            placeholder: kTransparentImage,
////            image: widget.postImage,
////            fit: BoxFit.cover,
////          ),
////        ),
//      ],
//    );
  }
}

//Container(
//height: MediaQuery.of(context).size.height / 2,
//child: Hero(
//tag: '1',
//child: FadeInImage.memoryNetwork(
//placeholder: kTransparentImage,
//image: widget.postImage,
//fit: BoxFit.cover,
//),
//),
//),
