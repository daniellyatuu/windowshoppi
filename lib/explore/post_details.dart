import 'package:flutter/material.dart';

import 'ExpandableText.dart';

class PostDetails extends StatefulWidget {
  final String caption;
  PostDetails({Key key, this.caption}) : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
//  String description = widget.caption;

  Widget _caption() {
    return ExpandableText(
      text: widget.caption,
      trimLines: 5,
      readLess: false,
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
