import 'package:fluttertoast/fluttertoast.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

class PostHeader extends StatelessWidget {
  final Post post;
  final String from;
  PostHeader({@required this.post, this.from = 'post_grid'});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 5.0, 0.0, 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              child: GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountPageInit(
                        accountId: post.accountId,
                      ),
                    ),
                  );
                  BlocProvider.of<AccountPostBloc>(context)
                    ..add(ResetAccountPostState());
                },
                child: BlocBuilder<AuthenticationBloc, AuthenticationStates>(
                  builder: (context, state) {
                    if (state is IsAuthenticated) {
                      return state.user.accountId == post.accountId
                          ? AccountOwnerProfile(post: post)
                          : OtherAccountProfile(post: post);
                    } else {
                      return OtherAccountProfile(post: post);
                    }
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: size.width * 0.02),
            child: TextButton(
              onPressed: () async {
                var res = await showDialog(
                  context: context,
                  builder: (context) {
                    return LoginOrRegister();
                  },
                );
                if (res != null) Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  Text(
                    'Follow ',
                    style: TextStyle(
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
