import 'package:flutter/material.dart';
import 'package:windowshoppi/src/app/home/home_files.dart';

class NotAuthHome extends StatefulWidget {
  const NotAuthHome({Key key}) : super(key: key);

  @override
  _NotAuthHomeState createState() => _NotAuthHomeState();
}

class _NotAuthHomeState extends State<NotAuthHome> {
  final List<String> _tabs = ['For You', 'Following'];

  int _activeTab = 0;

  void _tappedTab(int index) {
    if (index == _activeTab) {
      print('scroll to top');
      // BlocProvider.of<ScrollToTopBloc>(context)..add(ScrollToTop(index: index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: _tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  top: false,
                  bottom: true,
                  sliver: SliverAppBar(
                    title: Text('Windowshoppi'),
                    floating: true,
                    pinned: true,
                    forceElevated: innerBoxIsScrolled,
                    bottom: TabBar(
                      onTap: _tappedTab,
                      labelColor: Colors.red,
                      unselectedLabelColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        color: Colors.white,
                      ),
                      tabs: _tabs
                          .map(
                            (String name) => Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(name),
                              ),
                              // text: name,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Builder(
            builder: (BuildContext context) {
              final innerScrollController = PrimaryScrollController.of(context);

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  // scrollNotification
                  // print('outer ${DefaultTabController.of(context).index}');
                  setState(() {
                    _activeTab = DefaultTabController.of(context).index;
                  });
                  return true;
                },
                child: TabBarView(
                  children: [
                    HomeForYou(
                      primaryScrollController: innerScrollController,
                      tabName: _tabs[0],
                    ),
                    HomeFollowing(
                      primaryScrollController: innerScrollController,
                      tabName: _tabs[1],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
