import 'package:flutter/material.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';

class PostDetail extends StatefulWidget {
  final Post post;
  PostDetail({@required this.post});

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
      ),
      body: ListView(
        children: [
          PostHeader(),
          PostImage(
            postImage: widget.post.productPhoto,
          ),
          PostButton(),
          PostCaption(
            caption: widget.post.caption,
          ),
        ],
      ),
    );
  }
}
