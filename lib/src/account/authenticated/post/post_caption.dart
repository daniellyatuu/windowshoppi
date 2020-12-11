import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/authentication_bloc/authentication_states.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/utilities/expandable_text.dart';

class PostCaption extends StatelessWidget {
  final String caption;

  PostCaption({@required this.caption});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
      builder: (context, state) {
        if (state is IsAuthenticated) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: ExpandableText(
              username: state.user.username,
              text: caption,
              trimLines: 5,
              readLess: false,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
