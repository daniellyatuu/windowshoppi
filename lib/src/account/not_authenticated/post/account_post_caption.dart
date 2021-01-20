import 'package:url_launcher/url_launcher.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/utilities/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

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

          BlocBuilder<AuthenticationBloc, AuthenticationStates>(
            builder: (context, state) {
              if (state is IsAuthenticated) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    state.user.accountId == widget.post.accountId
                        ? widget.post.isUrlValid == false
                            ? Text(
                                'invalid url, please correct it. ',
                                style: Theme.of(context).textTheme.caption,
                              )
                            : Container()
                        : Container(),
                    if (widget.post.url != null &&
                            widget.post.isUrlValid == true ||
                        state.user.accountId == widget.post.accountId)
                      Container(
                        alignment: Alignment.centerRight,
                        child: OutlineButton(
                          onPressed: () => _launchURL('${widget.post.url}'),
                          child: Row(
                            children: [
                              Text('${widget.post.urlText} '),
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
                                          color: Colors.teal,
                                        );
                                      } else if (widget.post.isUrlValid ==
                                          false) {
                                        return Icon(
                                          Icons.warning_outlined,
                                          size: 16,
                                          color: Colors.red,
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
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.post.url != null &&
                        widget.post.isUrlValid == true)
                      Container(
                        alignment: Alignment.centerRight,
                        child: OutlineButton(
                          onPressed: () => _launchURL('${widget.post.url}'),
                          child: Row(
                            children: [
                              Text('${widget.post.urlText} '),
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
                                          color: Colors.teal,
                                        );
                                      } else if (widget.post.isUrlValid ==
                                          false) {
                                        return Icon(
                                          Icons.warning_outlined,
                                          size: 16,
                                          color: Colors.red,
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
                  ],
                );
              }
            },
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     BlocBuilder<AuthenticationBloc, AuthenticationStates>(
          //       builder: (context, state) {
          //         if (state is IsAuthenticated) {
          //           if (state.user.accountId == widget.post.accountId) {
          //             if (widget.post.isUrlValid == false) {
          //               return Text(
          //                 'invalid url, please correct it. ',
          //                 style: Theme.of(context).textTheme.caption,
          //               );
          //             } else {
          //               return Container();
          //             }
          //           } else {
          //             return Container();
          //           }
          //         } else {
          //           return Container();
          //         }
          //       },
          //     ),
          //     if (widget.post.url != null)
          //       Container(
          //         alignment: Alignment.centerRight,
          //         child: OutlineButton(
          //           onPressed: () => _launchURL('${widget.post.url}'),
          //           child: Row(
          //             children: [
          //               Text('${widget.post.urlText} '),
          //               BlocBuilder<AuthenticationBloc, AuthenticationStates>(
          //                 builder: (context, state) {
          //                   if (state is IsAuthenticated) {
          //                     if (state.user.accountId ==
          //                         widget.post.accountId) {
          //                       if (widget.post.isUrlValid == true) {
          //                         return Icon(
          //                           Icons.verified_outlined,
          //                           size: 16,
          //                           color: Colors.teal,
          //                         );
          //                       } else if (widget.post.isUrlValid == false) {
          //                         return Icon(
          //                           Icons.warning_outlined,
          //                           size: 16,
          //                           color: Colors.red,
          //                         );
          //                       } else {
          //                         return Container();
          //                       }
          //                     } else {
          //                       return Container();
          //                     }
          //                   } else {
          //                     return Container();
          //                   }
          //                 },
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
