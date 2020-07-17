import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';

class ImageSection extends StatefulWidget {
  final postImage;
  ImageSection({Key key, this.postImage}) : super(key: key);

  @override
  _ImageSectionState createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: Carousel(
            boxFit: BoxFit.cover,
            autoplay: false,
            animationCurve: Curves.fastOutSlowIn,
            dotSize: 4.0,
            dotIncreasedColor: Color(0xFFFF335C),
            dotBgColor: Colors.transparent,
            dotPosition: DotPosition.bottomCenter,
            dotColor: Colors.black,
            dotVerticalPadding: 2.0,
            showIndicator: true,
            indicatorBgPadding: 5.0,
            images: [
              for (var image in widget.postImage)
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: image.filename,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
            ],
          ),
        ),
//        Flexible(
//          fit: FlexFit.loose,
//          child: FadeInImage.memoryNetwork(
//            placeholder: kTransparentImage,
//            image: widget.postImage,
//            fit: BoxFit.cover,
//          ),
//        ),
      ],
    );
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
