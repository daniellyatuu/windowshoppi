import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
  final Post post;
  final String from;
  PostHeader({@required this.post, this.from});

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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountPageInit(
                          accountId: state.user.accountId,
                        ),
                      ),
                    );
                  },
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
                  ),
                ),
                BlocProvider<DeletePostBloc>(
                  create: (context) => DeletePostBloc(),
                  child: PostActionButtonInit(
                    post: post,
                    from: from,
                  ),
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
