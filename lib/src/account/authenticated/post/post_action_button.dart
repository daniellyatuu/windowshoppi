import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class PostActionButtonInit extends StatefulWidget {
  final Post post;
  final String from;
  PostActionButtonInit({@required this.post, this.from});

  @override
  _PostActionButtonInitState createState() => _PostActionButtonInitState();
}

class _PostActionButtonInitState extends State<PostActionButtonInit> {
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
        } else if (state is DeletePostNoInternet) {
          Navigator.of(context, rootNavigator: true).pop();
          _toastNotification('No internet connection', Colors.red,
              Toast.LENGTH_SHORT, ToastGravity.CENTER);
        } else if (state is DeletePostError) {
          Navigator.of(context, rootNavigator: true).pop();
          _toastNotification('Error occurred, please try again', Colors.red,
              Toast.LENGTH_LONG, ToastGravity.SNACKBAR);
        } else if (state is DeletePostSuccess) {
          // remove post
          BlocProvider.of<UserPostBloc>(context)
            ..add(UserPostRemove(post: widget.post));

          BlocProvider.of<AllPostBloc>(context)
            ..add(PostRemove(post: widget.post));

          BlocProvider.of<AccountPostBloc>(context)
            ..add(AccountPostRemove(post: widget.post));

          Navigator.of(context, rootNavigator: true).pop();
          // if (widget.from != 'post_list') Navigator.of(context).pop();
          _toastNotification('post deleted successfully', Colors.teal,
              Toast.LENGTH_LONG, ToastGravity.SNACKBAR);
        }
      },
      child: PostActionButton(
        post: widget.post,
        from: widget.from,
      ),
    );
  }
}

class PostActionButton extends StatefulWidget {
  final Post post;
  final String from;
  PostActionButton({@required this.post, @required this.from});

  @override
  _PostActionButtonState createState() => _PostActionButtonState();
}

class _PostActionButtonState extends State<PostActionButton> {
  _deletePost() async {
    BlocProvider.of<DeletePostBloc>(context)
      ..add(DeletePost(postId: widget.post.id));
  }

  _editPost() async {
    print('open page to edit post');
    // if (widget.from == 'post_detail') {
    //   Navigator.of(context).pop('edit_post');
    // } else if (widget.from == 'post_list') {
    //   // BlocProvider.of<ImageSelectionBloc>(context)
    //   //   ..add(EditPost(post: widget.post));
    // }
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
                          onTap: () => Navigator.of(context).pop('edit'),
                          // onTap: () {
                          //   BlocProvider.of<ImageSelectionBloc>(context)
                          //     ..add(CheckImage());
                          //   // BlocProvider.of<UserPostBloc>(context)
                          //   //   ..add(UserPostRefresh(accountId: 94));
                          //   // Navigator.push(
                          //   //   context,
                          //   //   MaterialPageRoute(
                          //   //     builder: (context) =>
                          //   //         UpdatePostInit(post: widget.post),
                          //   //   ),
                          //   // );
                          // },
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
          } else if (postAction == 'edit') {
            _editPost();
          }
        }
      },
      icon: Icon(Icons.more_vert),
    );
  }
}
