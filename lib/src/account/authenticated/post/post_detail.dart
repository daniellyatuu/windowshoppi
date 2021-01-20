import 'package:windowshoppi/src/utilities/expandable_text.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/material.dart';

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
          PostHeader(
            post: widget.post,
            from: 'post_detail',
          ),
          if (widget.post.group == 'vendor')
            if (widget.post.businessBio != '')
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(5.0),
                color: Colors.black87,
                child: ExpandableText(
                  text: '${widget.post.businessBio}',
                  widgetColor: Colors.white,
                  textBold: true,
                  trimLines: 2,
                  readMore: false,
                  readLess: false,
                ),
              ),
          PostImage(
            postImage: widget.post.productPhoto,
          ),
          AccountPostCaption(
            post: widget.post,
          ),
        ],
      ),
    );
  }
}
