import 'package:windowshoppi/src/utilities/expandable_text.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/material.dart';

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
          PostHeader(
            post: post,
          ),
          if (post.group == 'vendor')
            if (post.businessBio != '')
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(5.0),
                color: Colors.black87,
                child: ExpandableText(
                  text: '${post.businessBio}',
                  widgetColor: Colors.white,
                  textBold: true,
                  trimLines: 2,
                  readMore: false,
                  readLess: false,
                ),
              ),
          PostImage(
            postImage: post.productPhoto,
          ),
          AccountPostCaption(
            post: post,
          ),
        ],
      ),
    );
  }
}
