import 'package:flutter/material.dart';

class HomeFollowing extends StatefulWidget {
  final ScrollController primaryScrollController;
  final String tabName;

  HomeFollowing(
      {@required this.primaryScrollController, @required this.tabName});
  @override
  _HomeFollowingState createState() => _HomeFollowingState();
}

class _HomeFollowingState extends State<HomeFollowing> {
  final _scrollThreshold = 400.0;

  void _scrollListener() {
    if (context != null) {
      print('page 1 here');
      final maxScroll = this
          .widget
          .primaryScrollController
          // ignore: invalid_use_of_protected_member
          .positions
          .elementAt(0)
          .maxScrollExtent;
      final currentScroll =
          // ignore: invalid_use_of_protected_member
          this.widget.primaryScrollController.positions.elementAt(0).pixels;

      print('page 1 maxScroll $maxScroll');
      print('page 1 currentScroll $currentScroll');
      if ((maxScroll - currentScroll <= _scrollThreshold) &&
          (currentScroll > 0)) {
        print('load more following posts');
        // BlocProvider.of<UserPostBloc>(context)
        //   ..add(UserPostFetched(accountId: this.widget.accountId));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    this.widget.primaryScrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              // scrollNotification.
              print('page ${DefaultTabController.of(context).index} scroll');

              return true;
            },
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 20,
              key: PageStorageKey<String>(widget.tabName),
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.blueGrey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text('follow $index')],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
