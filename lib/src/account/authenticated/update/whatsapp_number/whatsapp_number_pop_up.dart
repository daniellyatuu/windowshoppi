import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WhatsappNumberPopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
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
            FaIcon(
              FontAwesomeIcons.whatsapp,
              size: 20.0,
              color: Color(0xFF06B862),
            ),
            Expanded(
              child: Text('  add number'),
            ),
          ],
        ),
        shape: new RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(
            color: Color(0xFF06B862),
            width: 2,
          ),
        ),
      ),
    );
  }
}
