import 'package:windowshoppi/src/search/search_files.dart';
import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            padding: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(50, 255, 255, 255),
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
            child: SearchArea(),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Posts',
              ),
              Tab(
                text: 'Accounts',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SearchedPostResult(),
            SearchedAccountResult(),
            // PostList(),
            // Accounts(),
          ],
        ),
      ),
    );
  }
}
