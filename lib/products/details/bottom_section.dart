import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSection extends StatefulWidget {
  final String postImage;
  BottomSection({Key key, this.postImage}) : super(key: key);
  @override
  _BottomSectionState createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
//            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      call();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 15.0,
                      child: FaIcon(
                        FontAwesomeIcons.phone,
                        size: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text('call'),
                ],
              ),
              SizedBox(
                width: 15.0,
              ),
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {},
                    child: CircleAvatar(
                      backgroundColor: Colors.lightGreen,
                      radius: 15.0,
                      child: FaIcon(
                        FontAwesomeIcons.whatsapp,
                        size: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text('chat'),
                ],
              ),
              SizedBox(
                width: 15.0,
              ),
              Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {},
                    child: CircleAvatar(
                      backgroundColor: Colors.black87,
                      radius: 15.0,
                      child: FaIcon(
                        FontAwesomeIcons.shareAlt,
                        size: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text('share'),
                ],
              ),
            ],
          ),
          RaisedButton(
            color: Colors.lightGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            onPressed: () {},
            child: Row(
              children: <Widget>[
                FaIcon(
                  FontAwesomeIcons.whatsapp,
                  size: 15.0,
                  color: Colors.white,
                ),
                Text(
                  ' share now',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

call() {
  String phoneNumber = "tel:0653900085";
  launch(phoneNumber);
}

//class BottomSection extends StatefulWidget {
//  final String postImage;
//  BottomSection({Key key, this.postImage}) : super(key: key);
//  @override
//  _BottomSectionState createState() => _BottomSectionState();
//}
//
//class _BottomSectionState extends State<BottomSection> {
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
////    String x = widget.postImage;
////    print(x);
////    final bytes = Io.File('images/shop.jpg').readAsBytesSync();
//
////    String img64 = base64Encode(bytes);
////    print(img64.substring(0, 100));
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          Row(
//            children: <Widget>[
//              Column(
//                children: <Widget>[
//                  CircleAvatar(
//                    radius: 16.0,
//                    backgroundColor: Colors.blue,
//                    child: IconButton(
//                      onPressed: () {
//                        call();
//                      },
//                      icon: FaIcon(FontAwesomeIcons.phone),
//                      color: Colors.white,
//                      iconSize: 14.0,
//                    ),
//                  ),
//                  Text('call'),
//                ],
//              ),
//              IconButton(
//                onPressed: () {
//                  FlutterOpenWhatsapp.sendSingleMessage(
//                      "+255625636291", "Hello");
//                },
//                icon: FaIcon(FontAwesomeIcons.whatsappSquare),
//              ),
//            ],
//          ),
//          IconButton(
//            onPressed: () {
//              FlutterShareMe().shareToWhatsApp(
//                  base64Image: widget.postImage,
//                  msg: 'product from windowshoppi');
//            },
//            icon: FaIcon(FontAwesomeIcons.shareAlt),
//          ),
//        ],
//      ),
//    );
//  }
//}
//
//call() {
//  String phoneNumber = "tel:0653900085";
//  launch(phoneNumber);
//}
