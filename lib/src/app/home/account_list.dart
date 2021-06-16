import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/authentication_bloc/authentication_states.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

class AccountList extends StatefulWidget {
  final List<AccountListModel> data;
  final String tabName;
  const AccountList({Key key, @required this.data, @required this.tabName})
      : super(key: key);

  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  Color _baseColor = Colors.grey[400];

  Color _highlightColor = Colors.grey[200];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: widget.data.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        AccountListModel account = widget.data[index];
        // return PeopleToFollowLoader();
        return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
          builder: (context, authState) {
            return GestureDetector(
              onTap: () async {
                if (authState is IsAuthenticated) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountPageInit(
                        accountId: account.accountId,
                        loggedInAccountId: authState.user.accountId,
                      ),
                    ),
                  );
                } else {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountPageInit(
                        accountId: account.accountId,
                      ),
                    ),
                  );
                }

                BlocProvider.of<AccountPostBloc>(context)
                  ..add(ResetAccountPostState());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${account.username}',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                '${account.accountName}',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                        ),
                        AccountListFollowBtn(
                          followingId: account.accountId,
                          isFollowed: account.isFollowed,
                        ),
                      ],
                    ),
                    if (account.postImages.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 6,
                            height: MediaQuery.of(context).size.width / 6,
                            child: account.accountProfile == null
                                ? FittedBox(
                                    child: Icon(
                                      Icons.account_circle,
                                      color: Colors.grey.shade400,
                                    ),
                                  )
                                : ClipOval(
                                    child: ExtendedImage.network(
                                      '${account.accountProfile}',
                                      cache: true,
                                      loadStateChanged:
                                          (ExtendedImageState state) {
                                        switch (state.extendedImageLoadState) {
                                          case LoadState.loading:
                                            return Shimmer.fromColors(
                                              baseColor: _baseColor,
                                              highlightColor: _highlightColor,
                                              child: Container(
                                                color: Colors.red,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    6,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    6,
                                              ),
                                            );

                                            // return CupertinoActivityIndicator();
                                            break;

                                          ///if you don't want override completed widget
                                          ///please return null or state.completedWidget
                                          //return null;
                                          //return state.completedWidget;
                                          case LoadState.completed:
                                            return ExtendedRawImage(
                                              fit: BoxFit.cover,
                                              image: state
                                                  .extendedImageInfo?.image,
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
                          for (String image in account.postImages)
                            Container(
                              width: MediaQuery.of(context).size.width / 8,
                              height: MediaQuery.of(context).size.width / 8,
                              child: ExtendedImage.network(
                                '$image',
                                cache: true,
                                loadStateChanged: (ExtendedImageState state) {
                                  switch (state.extendedImageLoadState) {
                                    case LoadState.loading:
                                      return Shimmer.fromColors(
                                        baseColor: _baseColor,
                                        highlightColor: _highlightColor,
                                        child: Container(
                                          color: Colors.red,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              6,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              6,
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
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class AccountListFollowBtn extends StatefulWidget {
  final int followingId;
  final bool isFollowed;
  const AccountListFollowBtn(
      {Key key, @required this.followingId, @required this.isFollowed})
      : super(key: key);

  @override
  _AccountListFollowBtnState createState() => _AccountListFollowBtnState();
}

class _AccountListFollowBtnState extends State<AccountListFollowBtn> {
  String followUnfollowTxt = '';

  void _setFollowUnfollowTxt() {
    if (widget.isFollowed == true) {
      setState(() {
        followUnfollowTxt = 'following';
      });
    } else {
      followUnfollowTxt = 'follow';
    }
  }

  @override
  void initState() {
    _setFollowUnfollowTxt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
      builder: (context, authState) {
        return ElevatedButton(
          onPressed: () async {
            if (authState is IsAuthenticated) {
              dynamic data = {
                'follower': authState.user.accountId,
                'following': widget.followingId,
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
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.teal,
          ),
          child: BlocConsumer<FollowUnfollowBloc, FollowUnfollowStates>(
            listener: (context, state) {
              if (state is FollowSuccess) {
                if (state.followingId == widget.followingId) {
                  setState(() {
                    followUnfollowTxt = 'Following';
                  });
                }
              } else if (state is UnfollowSuccess) {
                if (state.unFollowingId == widget.followingId) {
                  setState(() {
                    followUnfollowTxt = 'Follow';
                  });
                }
              }
            },
            builder: (context, state) {
              return Text(
                '$followUnfollowTxt ',
              );
            },
          ),
        );
      },
    );
  }
}
