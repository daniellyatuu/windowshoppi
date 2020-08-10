import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'dart:io' as Io;
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

class BottomSection extends StatefulWidget {
  final bussinessId;
  final String callNo, whatsapp;
  final postImage;
  final int activePhoto, loggedInBussinessId;
  BottomSection({
    Key key,
    this.callNo,
    this.whatsapp,
    this.postImage,
    this.activePhoto,
    this.bussinessId,
    this.loggedInBussinessId,
  }) : super(key: key);

  @override
  _BottomSectionState createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  bool _isSharingNow = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (widget.bussinessId != widget.loggedInBussinessId)
                Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        call(widget.callNo);
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
              if (widget.bussinessId != widget.loggedInBussinessId)
                widget.whatsapp != null
                    ? SizedBox(
                        width: 15.0,
                      )
                    : Text(''),
              if (widget.bussinessId != widget.loggedInBussinessId)
                widget.whatsapp != null
                    ? Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              chat(widget.whatsapp,
                                  "Hi there! I have seen your post on windowshoppi");
                            },
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF06B862),
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
                      )
                    : Text(''),
            ],
          ),
          AbsorbPointer(
            absorbing: _isSharingNow ? true : false,
            child: RaisedButton(
              color: _isSharingNow ? Color(0xFF08EA7C) : Color(0xFF06B862),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              onPressed: () async {
                setState(() {
                  _isSharingNow = true;
                });

                await shareToWhatsapp(
                    widget.postImage[widget.activePhoto].filename);
                setState(() {
                  _isSharingNow = false;
                });
              },
              child: Row(
                children: <Widget>[
                  if (_isSharingNow)
                    CupertinoActivityIndicator()
                  else
                    FaIcon(
                      FontAwesomeIcons.whatsapp,
                      size: 15.0,
                      color: Colors.white,
                    ),
                  _isSharingNow
                      ? Text(
                          '  wait ...',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Text(
                          ' share now',
                          style: TextStyle(color: Colors.white),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

call(String userNo) {
  String phoneNumber = "tel:$userNo";
  launch(phoneNumber);
}

chat(String userWhatsappNo, String initMessage) {
  FlutterOpenWhatsapp.sendSingleMessage("$userWhatsappNo", "$initMessage");
}

Future<File> urlToFile(String imageUrl) async {
// generate random number.
  var rng = new Random();
// get temporary directory of device.
  Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
  String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
  File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
  http.Response response = await http.get(imageUrl);
// write bodyBytes received in response to file.
  await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
  return file;
}

Future shareToWhatsapp(image) async {
  var _urlToFile = await urlToFile(image);

  final bytes = Io.File(_urlToFile.path).readAsBytesSync();

  String img64 = base64Encode(bytes);

  String _base64Image = "data:image/jpeg;base64," + img64;

  FlutterShareMe().shareToWhatsApp(
      base64Image: _base64Image,
      msg: 'From windowshoppi App, Download the App.');
}
