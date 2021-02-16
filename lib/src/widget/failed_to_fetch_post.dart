import 'package:flutter/material.dart';

class FailedToFetchPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.grey[700],
              size: 40,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Failed to fetch posts.Tap to try again',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
