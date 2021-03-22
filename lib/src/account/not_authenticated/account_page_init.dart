import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class AccountPageInit extends StatefulWidget {
  final int accountId;
  AccountPageInit({@required this.accountId}) : super();

  @override
  _AccountPageInitState createState() => _AccountPageInitState();
}

class _AccountPageInitState extends State<AccountPageInit> {
  void _resetAccountPost() {
    BlocProvider.of<AccountPostBloc>(context)..add(ResetAccountPostState());
  }

  @override
  void initState() {
    //rest account post state
    _resetAccountPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountDetailBloc>(
          create: (context) => AccountDetailBloc()
            ..add(GetAccountDetail(accountId: widget.accountId)),
        ),
      ],
      child: AccountPage(),
    );
  }
}
