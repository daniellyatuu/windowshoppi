import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                          : FollowButton();
                    } else {
                      return FollowButton();
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

class FollowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FollowUnfollowBloc, FollowUnfollowStates>(
      listener: (context, state) {
        print('listener for follow unfollow $state');
      },
      builder: (context, state) {
        return TextButton(
          onPressed: () {
            BlocProvider.of<FollowUnfollowBloc>(context)
              ..add(FollowAccount(accountId: 1));
          },
          child: Text(
            'Follow',
            style: TextStyle(
              color: Colors.teal,
            ),
          ),
        );
      },
    );
  }
}
