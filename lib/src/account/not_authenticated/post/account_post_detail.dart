import 'package:flutter/material.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';

class AccountPostDetail extends StatelessWidget {
  final Post post;
  AccountPostDetail({@required this.post}) : super();

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
          PostCaption(
            caption: post.caption,
          ),
        ],
      ),
    );
  }
}
