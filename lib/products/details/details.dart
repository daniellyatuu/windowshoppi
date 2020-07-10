import 'package:flutter/material.dart';
import 'package:windowshoppi/explore/post_details.dart';
import 'image_section.dart';
import 'bottom_section.dart';
import 'description_section.dart';
import 'package:windowshoppi/explore/top_section.dart';

class Details extends StatelessWidget {
  final singlePost;
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

//class Details extends StatefulWidget {
//  final singlePost;
//  Details({Key key, this.singlePost}) : super(key: key);
//
//  @override
//  _DetailsState createState() => _DetailsState();
//}
//
//class _DetailsState extends State<Details> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('product name'),
//      ),
//      body: ListView(
//        children: <Widget>[
//          TopSection(),
////          ImageSection(postImage: widget.imageUrl),
////          BottomSection(),
////          DescriptionSection(),
//        ],
//      ),
//    );
//  }
//}
