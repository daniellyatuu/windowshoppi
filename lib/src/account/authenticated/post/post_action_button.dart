import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';

class PostActionButtonInit extends StatefulWidget {
  final Post post;
  final String from;
  PostActionButtonInit({@required this.post, this.from});

  @override
  _PostActionButtonInitState createState() => _PostActionButtonInitState();
}

class _PostActionButtonInitState extends State<PostActionButtonInit> {
  void _notification(String txt, Color bgColor, Color btnColor) {
    final snackBar = SnackBar(
      content: Text(txt),
      backgroundColor: bgColor,
      action: SnackBarAction(
        label: 'Hide',
        textColor: btnColor,
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeletePostBloc, DeletePostStates>(
      listener: (context, state) {
        if (state is DeletePostLoading) {
          return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (dialogContext) => Material(
              type: MaterialType.transparency,
              child: Center(
                // Aligns the container to center
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Deleting post..',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is DeletePostError) {
          Navigator.of(context, rootNavigator: true).pop();
          _notification(
              'Error occurred, please try again.', Colors.red, Colors.white);
        } else if (state is DeletePostSuccess) {
          if (widget.from == 'post_list') {
            BlocProvider.of<UserPostBloc>(context)
              ..add(UserPostRemove(post: widget.post));
            Navigator.of(context, rootNavigator: true).pop();
            _notification(
                'Post deleted successfully.', Colors.teal, Colors.black);
          } else {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context).pop('success');
          }
        }
      },
      child: PostActionButton(
        post: widget.post,
      ),
    );
  }
}

class PostActionButton extends StatefulWidget {
  final Post post;
  PostActionButton({@required this.post});

  @override
  _PostActionButtonState createState() => _PostActionButtonState();
}

class _PostActionButtonState extends State<PostActionButton> {
  _deletePost() async {
    BlocProvider.of<DeletePostBloc>(context)
      ..add(DeletePost(postId: widget.post.id));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        var postAction = await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(
                    child: ListView(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdatePostInit()));
                          },
                          dense: true,
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                        ),
                        ListTile(
                          onTap: () => Navigator.of(context).pop('delete'),
                          dense: true,
                          leading: Icon(Icons.delete),
                          title: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
        if (postAction != null) {
          if (postAction == 'delete') {
            var postDeleteAction = await showDialog(
              context: context,
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Center(
                      child: ListView(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Center(
                              child: Text(
                                'Confirm Deletion',
                                style: Theme.of(context)
                                    .textTheme
                                    // ignore: deprecated_member_use
                                    .title,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Center(
                              child: Text(
                                'Delete this post?',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            onTap: () => Navigator.of(context).pop('delete'),
                            dense: true,
                            leading:
                                Icon(Icons.warning, color: Colors.red[300]),
                            title: Text(
                              'Delete',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[300]),
                            ),
                          ),
                          Divider(),
                          ListTile(
                            onTap: () => Navigator.of(context).pop(),
                            dense: true,
                            leading: Icon(Icons.clear),
                            title: Text('Don\'t delete'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
            if (postDeleteAction != null) {
              if (postDeleteAction == 'delete') {
                _deletePost();
              }
            }
          }
        }
      },
      icon: Icon(Icons.more_vert),
    );
  }
}
