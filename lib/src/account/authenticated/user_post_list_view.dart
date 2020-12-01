import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/account/account_files.dart';

class UserPostListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostBloc, PostStates>(
      listener: (context, PostStates state) {
        print(state);
      },
      builder: (context, PostStates state) {
        if (state is PostInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PostFailure) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                Text(
                  ' Error',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              ],
            ),
          );
        } else if (state is PostSuccess) {
          if (state.posts.isEmpty) {
            return Center(
              child: Text(
                'no posts',
                style: Theme.of(context).textTheme.headline6,
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Divider(),
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              return PostListWidget();
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
