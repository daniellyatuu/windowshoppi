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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
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
                    : Container(
                        child: Opacity(
                          opacity: 0.0,
                          child: IconButton(
                            onPressed: null,
                            icon: Icon(Icons.more_vert),
                          ),
                        ),
                      );
              } else {
                return Container(
                  child: Opacity(
                    opacity: 0.0,
                    child: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.more_vert),
                    ),
                  ),
                );
              }
            },
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
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: state.user.profileImage == null
                    ? FittedBox(
                        child:
                            Icon(Icons.account_circle, color: Colors.grey[400]),
                      )
                    : ClipOval(
                        child: ExtendedImage.network(
                          '${state.user.profileImage}',
                          cache: true,
                          loadStateChanged: (ExtendedImageState state) {
                            switch (state.extendedImageLoadState) {
                              case LoadState.loading:
                                return FittedBox(
                                  child: Icon(Icons.account_circle,
                                      color: Colors.grey[400]),
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
                                  child: Center(
                                    child: Icon(Icons.refresh),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(
                      '${state.user.username}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  if (post.taggedLocation != null)
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        '${post.taggedLocation}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13.0),
                      ),
                    ),
                ],
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
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: post.accountProfile == null
              ? FittedBox(
                  child: Icon(Icons.account_circle, color: Colors.grey[400]),
                )
              : ClipOval(
                  child: ExtendedImage.network(
                    '${post.accountProfile}',
                    cache: true,
                    loadStateChanged: (ExtendedImageState state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.loading:
                          return FittedBox(
                            child: Icon(Icons.account_circle,
                                color: Colors.grey[400]),
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
                            child: Center(
                              child: Icon(Icons.refresh),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Text(
                '${post.username}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            if (post.taggedLocation != null)
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  '${post.taggedLocation}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.0),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
