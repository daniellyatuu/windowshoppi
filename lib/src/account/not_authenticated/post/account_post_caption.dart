import 'package:url_launcher/url_launcher.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/utilities/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/widget/capitalization.dart';
import 'package:windowshoppi/src/utilities/action.dart';

class AccountPostCaption extends StatefulWidget {
  final Post post;
  AccountPostCaption({@required this.post});

  @override
  _AccountPostCaptionState createState() => _AccountPostCaptionState();
}

class _AccountPostCaptionState extends State<AccountPostCaption> {
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpandableText(
            accountId: widget.post.accountId,
            username: widget.post.username,
            text: widget.post.caption,
            trimLines: 5,
            readLess: false,
          ),
          if (widget.post.recommendationName != null)
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                width: (MediaQuery.of(context).size.width) -
                    (MediaQuery.of(context).size.width / 4),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'recommended ${widget.post.recommendationType}'
                            .capitalizeFirstofEach,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.grey[300]),
                      ),
                      child: Text(
                        '${widget.post.recommendationName}'.inCaps,
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Row(
            mainAxisAlignment: (widget.post.recommendationPhoneNumber != null &&
                    widget.post.url != null)
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            children: [
              if (widget.post.recommendationPhoneNumber != null)
                Container(
                  alignment: Alignment.centerRight,
                  child: RaisedButton(
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: () => call(
                        widget.post.recommendationPhoneDialCode +
                            widget.post.recommendationPhoneNumber),
                    child: Text(
                      'call'.inCaps,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              BlocBuilder<AuthenticationBloc, AuthenticationStates>(
                builder: (context, state) {
                  if (state is IsAuthenticated) {
                    return Column(
                      children: [
                        if ((widget.post.url != null &&
                                widget.post.isUrlValid == true) ||
                            (widget.post.url != null &&
                                widget.post.isUrlValid == null))
                          Container(
                            alignment: Alignment.centerRight,
                            child: RaisedButton(
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              onPressed: () => _launchURL('${widget.post.url}'),
                              child: Row(
                                children: [
                                  Text(
                                    '${widget.post.urlText} ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  BlocBuilder<AuthenticationBloc,
                                      AuthenticationStates>(
                                    builder: (context, state) {
                                      if (state is IsAuthenticated) {
                                        if (state.user.accountId ==
                                            widget.post.accountId) {
                                          if (widget.post.isUrlValid == true) {
                                            return Icon(
                                              Icons.verified_outlined,
                                              size: 16,
                                            );
                                          } else if (widget.post.isUrlValid ==
                                              false) {
                                            return Icon(
                                              Icons.warning_outlined,
                                              size: 16,
                                            );
                                          } else {
                                            return Container();
                                          }
                                        } else {
                                          return Container();
                                        }
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        state.user.accountId == widget.post.accountId
                            ? widget.post.isUrlValid == false
                                ? Text(
                                    'invalid url, please correct it. ',
                                    style: Theme.of(context).textTheme.caption,
                                  )
                                : Container()
                            : Container(),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        if ((widget.post.url != null &&
                                widget.post.isUrlValid == true) ||
                            (widget.post.url != null &&
                                widget.post.isUrlValid == null))
                          Container(
                            alignment: Alignment.centerRight,
                            child: RaisedButton(
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                // side: BorderSide(color: Colors.teal, width: 3),
                              ),
                              onPressed: () => _launchURL('${widget.post.url}'),
                              child: Text(
                                '${widget.post.urlText}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
