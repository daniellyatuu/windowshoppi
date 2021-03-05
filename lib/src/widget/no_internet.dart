import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.signal_cellular_connected_no_internet_4_bar_outlined,
            color: Colors.grey[700],
            size: 40,
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            'No internet.Tap to try again',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
