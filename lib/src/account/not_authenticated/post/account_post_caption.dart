import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/authentication_bloc/authentication_states.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/utilities/expandable_text.dart';

class AccountPostCaption extends StatelessWidget {
  final int accountId;
  final String caption;
  final String username;

  AccountPostCaption(
      {@required this.accountId,
      @required this.caption,
      @required this.username});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      child: ExpandableText(
        accountId: accountId,
        username: username,
        text: caption,
        trimLines: 5,
        readLess: false,
      ),
    );
  }
}
