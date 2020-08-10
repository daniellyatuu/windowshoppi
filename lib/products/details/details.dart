import 'package:flutter/material.dart';
import 'package:windowshoppi/explore/post_details.dart';
import 'package:windowshoppi/models/product.dart';
import 'image_section.dart';
import 'bottom_section.dart';
import 'description_section.dart';
import 'package:windowshoppi/explore/top_section.dart';

class Details extends StatefulWidget {
  final int loggedInBussinessId;
  final Product singlePost;
  Details({Key key, this.singlePost, this.loggedInBussinessId})
      : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int activePhoto = 0;

  _changeActivePhoto(value) async {
    setState(() {
      activePhoto = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        title: Text(singlePost.caption),
          ),
      body: ListView(
        children: <Widget>[
          TopSection(
            loggedInBussinessId: widget.loggedInBussinessId,
            bussinessId: widget.singlePost.bussiness,
            account: widget.singlePost.accountName,
            location: widget.singlePost.businessLocation,
          ),
          ImageSection(
            postImage: widget.singlePost.productPhoto,
            activeImage: (value) => _changeActivePhoto(value),
          ),
          BottomSection(
            loggedInBussinessId: widget.loggedInBussinessId,
            bussinessId: widget.singlePost.bussiness,
            postImage: widget.singlePost.productPhoto,
            activePhoto: activePhoto,
            callNo: widget.singlePost.callNumber,
            whatsapp: widget.singlePost.whatsappNumber,
          ),
          PostDetails(caption: widget.singlePost.caption),
        ],
      ),
    );
  }
}
