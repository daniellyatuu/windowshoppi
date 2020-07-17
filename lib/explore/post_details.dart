import 'package:flutter/material.dart';

class PostDetails extends StatefulWidget {
  final String caption;
  PostDetails({Key key, this.caption}) : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
//  String description = widget.caption;

  Widget _caption() {
    return Text(
      widget.caption,
      textAlign: TextAlign.justify,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: _caption(),
    );
  }
}
