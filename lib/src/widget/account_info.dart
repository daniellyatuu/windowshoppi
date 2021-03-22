import 'package:flutter/material.dart';

class AccountInfo extends StatelessWidget {
  final String name;
  final int number;
  AccountInfo({@required this.name, @required this.number});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(
            '$name',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            '$number',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
