import 'package:flutter/material.dart';

class PostDetails extends StatefulWidget {
  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  String description = 'some description about the product';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Text(
        description,
        textAlign: TextAlign.justify,
      ),
    );
  }
}
