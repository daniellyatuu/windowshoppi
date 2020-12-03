import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';

class PostButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
        builder: (context, state) {
      if (state is IsAuthenticated) {
        return Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            // call(widget.callNo);
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
                  if (state.user.whatsapp != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              // chat(widget.whatsapp,
                              //     "Hi there! I have seen your post on windowshoppi");
                              // AppAvailability.checkAvailability(_packageName)
                              //     .then((_) async {
                              //   await chat(widget.whatsapp,
                              //       "Hi there! I have seen your post on windowshoppi");
                              // }).catchError((err) {
                              //   Scaffold.of(context).hideCurrentSnackBar();
                              //   _notification(
                              //       'WhatsApp not found', Colors.black, Colors.red);
                              // });
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
              ),
              AbsorbPointer(
                absorbing: false,
                child: RaisedButton(
                  color: Color(0xFF06B862),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: () async {
                    // setState(() {
                    //   _isSharingNow = true;
                    // });
                    // await shareToWhatsapp(
                    //     widget.postImage[widget.activePhoto].filename);

                    // await AppAvailability.checkAvailability(_packageName)
                    //     .then((_) async {
                    //   await shareToWhatsapp(
                    //       widget.postImage[widget.activePhoto].filename);
                    // }).catchError((err) {
                    //   Scaffold.of(context).hideCurrentSnackBar();
                    //   _notification('WhatsApp not found', Colors.black, Colors.red);
                    // });

                    // setState(() {
                    //   _isSharingNow = false;
                    // });
                  },
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
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
