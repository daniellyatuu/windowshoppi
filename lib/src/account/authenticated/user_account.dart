import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class UserAccount extends StatefulWidget {
  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageSelectionBloc, ImageSelectionStates>(
      builder: (context, state) {
        if (state is ImageNotSelected) {
          return PostView();
        } else if (state is ImageSelected) {
          print('image from = ${state.imageUsedFor}');
          if (state.imageUsedFor == 'post') {
            return BlocProvider<CreatePostBloc>(
              create: (context) => CreatePostBloc(),
              child: PostCreate(),
            );
          } else if (state.imageUsedFor == 'profile') {
            // return BlocProvider<CreateProfileBloc>(
            //   create: (context) => CreateProfileBloc(),
            //   child:
            // );
            return ProfileCreate();
          } else {
            return Container();
          }
        } else if (state is EditPostActive) {
          return UpdatePostInit(post: state.post);
        } else if (state is ImageError) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => BlocProvider.of<ImageSelectionBloc>(context)
                  ..add(CheckImage()),
                icon: Icon(Icons.clear),
              ),
            ),
            body: Center(
              child: Text(
                '${state.error}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
