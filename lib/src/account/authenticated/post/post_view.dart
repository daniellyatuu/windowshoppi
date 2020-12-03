import 'package:flutter/material.dart';
import 'package:windowshoppi/src/account/account_files.dart';

class PostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        children: [
          PostGridView(),
          PostListView(),
        ],
      ),
    );
  }
}
