import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class UserAccount extends StatefulWidget {
  final int accountId;
  UserAccount({@required this.accountId});

  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  void _fetchUserPost() {
    BlocProvider.of<UserPostBloc>(context)
      ..add(UserPostFetchedInit(accountId: widget.accountId));
  }

  @override
  void initState() {
    //fetch user post
    _fetchUserPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PostView();
  }
}
