import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

class PostListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserPostBloc, UserPostStates>(
      listener: (context, state) {
        print('User Post Listener = $state');
        if (state is InvalidToken) {
          BlocProvider.of<AuthenticationBloc>(context)..add(DeleteToken());
        }
      },
      builder: (context, state) {
        if (state is UserPostInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is UserPostFailure) {
          return Center(
            child: Text(
              'Failed to fetch posts',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        } else if (state is UserPostSuccess) {
          var data = state.posts;
          if (state.posts.isEmpty) {
            return Center(
              child: Text(
                'No Posts',
                style: Theme.of(context).textTheme.headline6,
              ),
            );
          }

          return ListView(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => Divider(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      PostHeader(),
                      PostImage(
                        postImage: data[index].productPhoto,
                      ),
                      PostButton(),
                      PostCaption(
                        caption: data[index].caption,
                      ),
                    ],
                  );
                },
              ),
              BottomLoader(),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
