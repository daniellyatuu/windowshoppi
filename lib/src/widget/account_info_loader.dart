import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

class AccountInfoLoader extends StatefulWidget {
  @override
  _AccountInfoLoaderState createState() => _AccountInfoLoaderState();
}

class _AccountInfoLoaderState extends State<AccountInfoLoader> {
  Color _baseColor = Colors.grey[400];

  Color _highlightColor = Colors.grey[200];

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 5,
              child: Container(
                margin: EdgeInsets.only(bottom: 2.0),
                color: _baseColor,
                height: 32.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 5,
              child: Container(
                margin: EdgeInsets.only(bottom: 2.0),
                color: _baseColor,
                height: 32.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 5,
              child: Container(
                margin: EdgeInsets.only(bottom: 2.0),
                color: _baseColor,
                height: 32.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
