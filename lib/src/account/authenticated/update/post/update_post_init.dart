import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/material.dart';

class UpdatePostInit extends StatelessWidget {
  final Post post;
  UpdatePostInit({@required this.post}) : super();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdatePostBloc>(
      create: (context) => UpdatePostBloc(),
      child: UpdatePostForm(post: post),
    );
  }
}
