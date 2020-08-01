import 'package:flutter/material.dart';
import 'package:windowshoppi/explore/post_details.dart';
import 'package:windowshoppi/models/product.dart';
import 'image_section.dart';
import 'bottom_section.dart';
import 'description_section.dart';
import 'package:windowshoppi/explore/top_section.dart';

class Details extends StatelessWidget {
  final Product singlePost;
  Details({Key key, this.singlePost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        title: Text(singlePost.caption),
          ),
      body: ListView(
        children: <Widget>[
          TopSection(
            account: singlePost.accountName,
            location: singlePost.businessLocation,
          ),
          ImageSection(postImage: singlePost.productPhoto),
          BottomSection(
            callNo: singlePost.callNumber,
            whatsapp: singlePost.whatsappNumber,
          ),
          PostDetails(caption: singlePost.caption),
        ],
      ),
    );
  }
}
