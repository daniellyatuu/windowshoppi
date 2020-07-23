import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/products/details/details.dart';
import 'package:windowshoppi/routes/fade_transition.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostSection extends StatefulWidget {
  final postImage;
  PostSection({Key key, this.postImage}) : super(key: key);

  @override
  _PostSectionState createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {
  bool _imageCover = true;
  int _activePhoto = 1;

  void _changeImageView() {
    setState(() {
      _imageCover = !_imageCover;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
  }
}
