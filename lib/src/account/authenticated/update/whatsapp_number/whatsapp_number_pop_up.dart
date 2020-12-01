import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class WhatsappNumberPopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        showDialog(
          useRootNavigator: false,
          context: context,
          builder: (context) {
            return BlocProvider<WhatsappNumberBloc>(
              create: (context) => WhatsappNumberBloc(),
              child: Dialog(
                child: WhatsappNumberForm(),
              ),
            );
          },
        );
      },
      child: Row(
        children: [
          Text('edit '),
          Icon(
            Icons.edit,
            size: 14,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }
}
