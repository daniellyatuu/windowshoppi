import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
  final Post post;
  PostHeader({@required this.post});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
      builder: (context, state) {
        if (state is IsAuthenticated) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: FittedBox(
                          child: Icon(Icons.account_circle,
                              color: Colors.grey[300]),
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
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
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
                                      onTap: () => Navigator.of(context).pop({
                                        'status': 'edit',
                                        'id': 12,
                                      }),
                                      dense: true,
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                    ),
                                    ListTile(
                                      onTap: () => Navigator.of(context).pop({
                                        'status': 'delete',
                                        'id': 1,
                                      }),
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
                      if (postAction['status'] == 'delete') {
                        var deletePost = await showDialog(
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
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
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
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Center(
                                          child: Text(
                                            'Delete this post?',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      ListTile(
                                        onTap: () => Navigator.of(context).pop({
                                          'confirm': 'yes',
                                          'id': 23,
                                        }),
                                        dense: true,
                                        leading: Icon(Icons.warning,
                                            color: Colors.red[300]),
                                        title: Text(
                                          'Delete',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red[300]),
                                        ),
                                      ),
                                      Divider(),
                                      ListTile(
                                        onTap: () =>
                                            Navigator.of(context).pop(),
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
                        if (deletePost != null) {
                          if (deletePost['confirm'] == 'yes') {
                            print('delete this post');
                            print(post);
                          }
                        }
                      } else {
                        print('edit post');
                        // var result = await Navigator.push(
                        //   context,
                        //   FadeRoute(
                        //     widget: EditProduct(
                        //       editPost: widget.post,
                        //       newCaption: _caption,
                        //       // newCaption:
                        //     ),
                        //   ),
                        // );

                      }
                    }
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
