import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageSection extends StatefulWidget {
  final String postImage;
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
        Flexible(
          fit: FlexFit.loose,
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: widget.postImage,
            fit: BoxFit.cover,
          ),
        ),
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
