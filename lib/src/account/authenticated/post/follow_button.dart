import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

class FollowButton extends StatefulWidget {
  final int followingId;
  final bool isFollowed;
  FollowButton({@required this.followingId, @required this.isFollowed});

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
    print('BUILD IN HERE');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
      builder: (context, authState) {
        return TextButton(
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

              if (res != null) {
                Navigator.of(context).pop();
              }
            }
          },
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
              return BlocBuilder<FollowedAccountBloc, FollowedAccountStates>(
                  builder: (context, followedState) {
                if (followedState is FollowedUnfollowedAccounts) {
                  if (followedState.followedAccounts
                      .contains(widget.followingId)) {
                    return Text(
                      'Following ',
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    );
                  } else if (followedState.unfollowedAccounts
                      .contains(widget.followingId)) {
                    return Text(
                      'Follow ',
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Text(
                    '$followUnfollowTxt ',
                    style: TextStyle(
                      color: Colors.teal,
                    ),
                  );
                }
              });
            },
          ),
        );
      },
    );
  }
}

// class FollowUnfollowBtn extends StatelessWidget {
//   const FollowUnfollowBtn({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () async {
//         if (widget.isFollowed == false) {
//           if (authState is IsAuthenticated) {
//             dynamic data = {
//               'follower': authState.user.accountId,
//               'following': widget.followingId,
//             };
//
//             BlocProvider.of<FollowUnfollowBloc>(context)
//               ..add(FollowAccount(followData: data));
//           } else if (authState is IsNotAuthenticated) {
//             var res = await showDialog(
//               context: context,
//               builder: (context) {
//                 return LoginOrRegister();
//               },
//             );
//
//             if (res != null) {
//               Navigator.of(context).pop();
//             }
//           }
//         } else {
//           print('unfollow account');
//         }
//       },
//       child: Row(
//         children: [
//           Text(
//             widget.isFollowed ? 'Following ' : 'Follow ',
//             style: TextStyle(
//               color: Colors.teal,
//             ),
//           ),
//           if (state is FollowLoading)
//             state.followingId == widget.followingId
//                 ? SizedBox(
//                     height: 12,
//                     width: 12,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                     ),
//                   )
//                 : Container(),
//         ],
//       ),
//     );
//   }
// }
