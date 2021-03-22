import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class OtherAccount extends StatefulWidget {
  final int accountId;
  OtherAccount({@required this.accountId});

  @override
  _OtherAccountState createState() => _OtherAccountState();
}

class _OtherAccountState extends State<OtherAccount> {
  void _fetchAccountPost() {
    BlocProvider.of<AccountPostBloc>(context)
      ..add(AccountPostInitFetched(accountId: this.widget.accountId));
  }

  @override
  void initState() {
    //fetch account post
    _fetchAccountPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AccountPostList();
  }
}
