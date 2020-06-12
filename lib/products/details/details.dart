import 'package:flutter/material.dart';
import 'top_section.dart';
import 'image_section.dart';
import 'bottom_section.dart';
import 'description_section.dart';

class Details extends StatefulWidget {
  final String imageUrl;
  Details({Key key, @required this.imageUrl}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('product name'),
      ),
      body: ListView(
        children: <Widget>[
          TopSection(),
          ImageSection(postImage: widget.imageUrl),
          BottomSection(postImage: widget.imageUrl),
          DescriptionSection(),
        ],
      ),
    );
  }
}
