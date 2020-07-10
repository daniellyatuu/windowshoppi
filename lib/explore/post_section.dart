import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/products/details/details.dart';
import 'package:windowshoppi/routes/fade_transition.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostSection extends StatefulWidget {
  final postData;
  PostSection({Key key, this.postData}) : super(key: key);

  @override
  _PostSectionState createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          FadeRoute(
            widget: Details(singlePost: widget.postData),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Carousel(
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
            for (var image in widget.postData.productPhoto)
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
    );
  }
}

//Flexible(
//fit: FlexFit.loose,
//child: GestureDetector(
//onTap: () {
//Navigator.push(
//context,
//FadeRoute(
////              widget: Details(imageUrl: imageUrl),
//),
//);
//},
//child: Image.network(
//'imageUdl',
//fit: BoxFit.cover,
//),
//),
//);
