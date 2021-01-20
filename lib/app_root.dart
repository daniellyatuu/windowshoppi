import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/explore/explore_files.dart';
import 'package:windowshoppi/src/search/search_files.dart';
import 'package:custom_navigator/custom_navigation.dart';
import 'package:windowshoppi/src/home/home_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRoot extends StatefulWidget {
  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  int _currentIndex = 0;
  bool isLoggedIn = false;

  final List<Widget> _children = [
    HomeInit(),
    ExploreInit(),
    Search(),
    Account(),
  ];

  void _onTappedBar(int index) {
    if (navigatorKey.currentState.canPop()) {
      navigatorKey.currentState.popUntil((route) => route.isFirst);
    } else {
      BlocProvider.of<ScrollToTopBloc>(context)..add(ScrollToTop(index: index));
    }

    setState(() {
      _currentIndex = index;
    });
  }

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomNavigator(
        navigatorKey: navigatorKey,
        home: _children[_currentIndex],
        pageRoute: PageRoutes.materialPageRoute,
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedColor: Color(0xff040307),
        strokeColor: Color(0x30040307),
        unSelectedColor: Color(0xffacacac),
        backgroundColor: Colors.white,
        items: [
          CustomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          CustomNavigationBarItem(
            icon: Icon(Icons.explore),
            title: Text('Explore'),
          ),
          CustomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.search),
            title: Text('Search'),
          ),
          CustomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Account'),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onTappedBar,
      ),
    );
  }
}
