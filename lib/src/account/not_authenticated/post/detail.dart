import 'package:flutter/material.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';

class Detail extends StatelessWidget {
  final Post post;
  Detail({@required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
      ),
      body: ListView(
        children: [
          TopHeader(
            post: post,
          ),
          PostImage(
            postImage: post.productPhoto,
          ),
          AccountPostButton(
            post: post,
          ),
          AccountPostCaption(
            accountId: post.accountId,
            username: post.username,
            caption: post.caption,
          ),
        ],
      ),
    );
  }
}
