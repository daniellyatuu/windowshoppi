// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:windowshoppi/src/account/account_files.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:windowshoppi/src/bloc/bloc_files.dart';
//
// class AuthOtherAccount extends StatefulWidget {
//   final int accountId;
//   AuthOtherAccount({Key key, @required this.accountId}) : super(key: key);
//
//   @override
//   _AuthOtherAccountState createState() => _AuthOtherAccountState();
// }
//
// class _AuthOtherAccountState extends State<AuthOtherAccount> {
//   void _fetchAccountPost() {
//     print('fetch user when auth');
//     // BlocProvider.of<AccountPostBloc>(context)
//     //   ..add(AccountPostInitFetched(accountId: this.widget.accountId));
//   }
//
//   @override
//   void initState() {
//     //fetch account post
//     _fetchAccountPost();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AccountPostList();
//   }
// }
