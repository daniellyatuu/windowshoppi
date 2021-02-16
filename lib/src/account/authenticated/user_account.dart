import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class UserAccount extends StatefulWidget {
  final int accountId;
  UserAccount({@required this.accountId});

  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  void _fetchUserPost() {
    BlocProvider.of<UserPostBloc>(context)
      ..add(UserPostFetchedInit(accountId: widget.accountId));
  }

  @override
  void initState() {
    //fetch user post
    _fetchUserPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PostView();

    // return BlocBuilder<ImageSelectionBloc, ImageSelectionStates>(
    //   builder: (context, state) {
    //     if (state is ImageNotSelected) {
    //       return PostView(); ############# ok
    //     } else if (state is ImageSelected) {
    //       if (state.imageUsedFor == 'post') {
    //         return BlocProvider<CreatePostBloc>(
    //           create: (context) => CreatePostBloc(),
    //           child: PostCreate(), ########### ok
    //         );
    //       } else if (state.imageUsedFor == 'profile') {
    //         return ProfileCreate(); ########## ok
    //       } else {
    //         return Container();
    //       }
    //     } else if (state is EditPostActive) {
    //       return UpdatePostInit(post: state.post);
    //     } else if (state is ImageError) {
    //       return Scaffold(
    //         appBar: AppBar(
    //           leading: IconButton(
    //             onPressed: () => BlocProvider.of<ImageSelectionBloc>(context)
    //               ..add(CheckImage()),
    //             icon: Icon(Icons.clear),
    //           ),
    //         ),
    //         body: Center(
    //           child: Text(
    //             '${state.error}',
    //             style: Theme.of(context).textTheme.headline6,
    //           ),
    //         ),
    //       );
    //     } else {
    //       return Container();
    //     }
    //   },
    // );
  }
}
