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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int activePhoto = 0;
  String newCaption;
  bool edited = false;

  _changeActivePhoto(value) async {
    setState(() {
      activePhoto = value;
    });
  }

  // _closeActivePage(value) async {
  //   if (value == true) {
  //     Navigator.of(context).pop(value);
  //   }
  // }

  // _updateCaption(value) async {
  //   print(value);
  //   if (value != null) {
  //     setState(() {
  //       edited = true;
  //       newCaption = value['caption'];
  //     });
  //     _notification('post updated successfully', Colors.black, Colors.red);
  //   }
  // }

  // void _notification(String txt, Color bgColor, Color btnColor) {
  //   final snackBar = SnackBar(
  //     content: Text(txt),
  //     backgroundColor: bgColor,
  //     action: SnackBarAction(
  //       label: 'Hide',
  //       textColor: btnColor,
  //       onPressed: () {
  //         Scaffold.of(context).hideCurrentSnackBar();
  //       },
  //     ),
  //   );
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _scaffoldKey.currentState.showSnackBar(snackBar);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Post'),
      ),
      body: ListView(
        children: <Widget>[
          TopSection(
            post: widget.singlePost,
            loggedInBussinessId: widget.loggedInBussinessId,
            onDeletePost: (value) =>
                value ? Navigator.of(context).pop('deleted') : null,
            isDataUpdated: (value) =>
                value ? Navigator.of(context).pop('updated') : null,
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
          PostDetails(caption: edited ? newCaption : widget.singlePost.caption),
        ],
      ),
    );
  }
}
