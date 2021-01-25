import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';

class VendorUpdateProfileInit extends StatelessWidget {
  final User user;
  VendorUpdateProfileInit({@required this.user}) : super();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VendorProfileUpdateBloc>(
      create: (context) => VendorProfileUpdateBloc(),
      child: VendorUpdateProfileForm(
        user: user,
      ),
    );
  }
}
