import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/utilities/action.dart';

class AccountPostButton extends StatefulWidget {
  final Post post;
  AccountPostButton({@required this.post});

  @override
  _AccountPostButtonState createState() => _AccountPostButtonState();
}

class _AccountPostButtonState extends State<AccountPostButton> {
  bool _isSharingNow = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          widget.post.group == 'vendor'
              ? Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              call(widget.post.callNumber);
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
                    ),
                    if (widget.post.whatsappNumber != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                chat(widget.post.whatsappNumber,
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
                        ),
                      ),
                  ],
                )
              : Container(),
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
                try {
                  var result = await shareToWhatsapp(
                      widget.post.productPhoto[0].filename);

                  if (result == 'false') {
                    Flushbar(
                      icon: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ),
                      titleText: Text(
                        'Image sharing failed!',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      messageText: Text(
                        'make sure whatsapp is installed on your device',
                        style: TextStyle(color: Colors.white, fontSize: 13.0),
                      ),
                      duration: Duration(seconds: 4),
                      flushbarPosition: FlushbarPosition.TOP,
                    )..show(context);
                  }
                } catch (_) {
                  Flushbar(
                    icon: Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                    message: 'Couldn\'t share image.please try again',
                    duration: Duration(seconds: 4),
                    flushbarPosition: FlushbarPosition.TOP,
                  )..show(context);
                }

                setState(() {
                  _isSharingNow = false;
                });
              },
              child: Row(
                children: <Widget>[
                  _isSharingNow
                      ? CupertinoActivityIndicator()
                      : FaIcon(
                          FontAwesomeIcons.whatsapp,
                          size: 15.0,
                          color: Colors.white,
                        ),
                  _isSharingNow
                      ? Text(
                          ' wait...',
                        )
                      : Text(
                          ' share now',
                          style: TextStyle(color: Colors.white),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
