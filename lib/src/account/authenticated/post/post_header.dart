import 'package:fluttertoast/fluttertoast.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

class PostHeader extends StatelessWidget {
  final Post post;
  final String from;
  PostHeader({@required this.post, this.from = 'post_grid'});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 5.0, 0.0, 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountPageInit(
                        accountId: post.accountId,
                      ),
                    ),
                  );
                },
                child: BlocBuilder<AuthenticationBloc, AuthenticationStates>(
                  builder: (context, state) {
                    if (state is IsAuthenticated) {
                      return state.user.accountId == post.accountId
                          ? AccountOwnerProfile(post: post)
                          : OtherAccountProfile(post: post);
                    } else {
                      return OtherAccountProfile(post: post);
                    }
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: size.width * 0.02),
            child: Row(
              children: [
                BlocBuilder<AuthenticationBloc, AuthenticationStates>(
                  builder: (context, state) {
                    if (state is IsAuthenticated) {
                      return state.user.accountId == post.accountId
                          ? Container()
                          : FollowButton(
                              following: post.accountId,
                            );
                    } else {
                      return FollowButton(
                        following: post.accountId,
                      );
                    }
                  },
                ),
                BlocBuilder<AuthenticationBloc, AuthenticationStates>(
                  builder: (context, state) {
                    if (state is IsAuthenticated) {
                      return state.user.accountId == post.accountId
                          ? MultiBlocProvider(
                              providers: [
                                BlocProvider<DeletePostBloc>(
                                  create: (context) => DeletePostBloc(),
                                ),
                              ],
                              child: PostActionButtonInit(
                                post: post,
                                from: from,
                              ),
                            )
                          : Container();
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AccountOwnerProfile extends StatelessWidget {
  final Post post;
  AccountOwnerProfile({@required this.post});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
      builder: (context, state) {
        if (state is IsAuthenticated) {
          return Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  shape: BoxShape.circle,
                ),
                child: state.user.profileImage == null
                    ? FittedBox(
                        child: Icon(Icons.account_circle, color: Colors.white),
                      )
                    : ClipOval(
                        child: ExtendedImage.network(
                          '${state.user.profileImage}',
                          cache: true,
                          loadStateChanged: (ExtendedImageState state) {
                            switch (state.extendedImageLoadState) {
                              case LoadState.loading:
                                return FittedBox(
                                  child: Icon(
                                    Icons.account_circle,
                                    color: Colors.white,
                                  ),
                                );
                                break;

                              ///if you don't want override completed widget
                              ///please return null or state.completedWidget
                              //return null;
                              //return state.completedWidget;
                              case LoadState.completed:
                                return ExtendedRawImage(
                                  fit: BoxFit.cover,
                                  image: state.extendedImageInfo?.image,
                                );
                                break;
                              case LoadState.failed:
                                // _controller.reset();
                                return GestureDetector(
                                  child: FittedBox(
                                    child: Icon(
                                      Icons.account_circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    state.reLoadImage();
                                  },
                                );
                                break;
                            }
                            return null;
                          },
                        ),
                      ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${state.user.username}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    if (post.taggedLocation != null)
                      Text(
                        '${post.taggedLocation}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13.0),
                      ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class OtherAccountProfile extends StatelessWidget {
  final Post post;
  OtherAccountProfile({@required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            shape: BoxShape.circle,
          ),
          child: post.accountProfile == null
              ? FittedBox(
                  child: Icon(Icons.account_circle, color: Colors.white),
                )
              : ClipOval(
                  child: ExtendedImage.network(
                    '${post.accountProfile}',
                    cache: true,
                    loadStateChanged: (ExtendedImageState state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.loading:
                          return FittedBox(
                            child: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                            ),
                          );
                          break;

                        ///if you don't want override completed widget
                        ///please return null or state.completedWidget
                        //return null;
                        //return state.completedWidget;
                        case LoadState.completed:
                          return ExtendedRawImage(
                            fit: BoxFit.cover,
                            image: state.extendedImageInfo?.image,
                          );
                          break;
                        case LoadState.failed:
                          // _controller.reset();
                          return GestureDetector(
                            child: FittedBox(
                              child: Icon(
                                Icons.account_circle,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              state.reLoadImage();
                            },
                          );
                          break;
                      }
                      return null;
                    },
                  ),
                ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${post.username}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              if (post.taggedLocation != null)
                Text(
                  '${post.taggedLocation}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.0),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class FollowButton extends StatefulWidget {
  final int following;
  FollowButton({@required this.following});

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  void _toastNotification(
      String txt, Color color, Toast length, ToastGravity gravity) {
    // close active toast if any before open new one
    Fluttertoast.cancel();

    Fluttertoast.showToast(
        msg: '$txt',
        toastLength: length,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
      builder: (context, authState) {
        return BlocConsumer<FollowUnfollowBloc, FollowUnfollowStates>(
          listener: (context, state) {
            print('listener for follow unfollow $state');
          },
          builder: (context, state) {
            return TextButton(
              onPressed: () async {
                if (authState is IsAuthenticated) {
                  dynamic data = {
                    'follower': authState.user.accountId,
                    'following': widget.following,
                  };

                  BlocProvider.of<FollowUnfollowBloc>(context)
                    ..add(FollowAccount(followData: data));
                } else if (authState is IsNotAuthenticated) {
                  var res = await showDialog(
                    context: context,
                    builder: (context) {
                      return LoginOrRegister();
                    },
                  );

                  if (res != null) {
                    Navigator.of(context).pop();
                  }
                } else if (authState is AuthNoInternet) {
                  _toastNotification('No internet connection', Colors.red,
                      Toast.LENGTH_SHORT, ToastGravity.CENTER);

                  // Retry
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(CheckUserLoggedInStatus());
                } else if (authState is AuthenticationError) {
                  _toastNotification('Error occurred, please try again.',
                      Colors.red, Toast.LENGTH_LONG, ToastGravity.SNACKBAR);

                  // Delete Token
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(DeleteToken());
                }
              },
              child: Row(
                children: [
                  Text(
                    'Follow ',
                    style: TextStyle(
                      color: Colors.teal,
                    ),
                  ),
                  // if (state is FollowLoading)
                  //   SizedBox(
                  //     height: 12,
                  //     width: 12,
                  //     child: CircularProgressIndicator(
                  //       strokeWidth: 2,
                  //     ),
                  //   )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
