import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:windowshoppi/home_page/home_page.dart';
import 'package:windowshoppi/managers/NavigationManager.dart';
import 'package:custom_navigator/custom_navigation.dart';
import 'package:windowshoppi/explore/explore.dart';
import 'package:windowshoppi/search/Search.dart';
import 'package:windowshoppi/Provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:windowshoppi/src/account/account_files.dart';

class AppNavigation extends StatefulWidget {
  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;
  bool isLoggedIn = false;

  final List<Widget> _children = [
    // HomePage(),
    Center(
      child: Text('Homepage'),
    ),
    // Home(),
    // Explore(),
    Center(
      child: Text('Explore page'),
    ),
    // Search(),
    Center(
      child: Text('Search page'),
    ),
    // UserAuth(),
    // LoginRegister(),
    Account(),
  ];

  void _onTappedBar(int index) {
    if (navigatorKey.currentState.canPop()) {
      navigatorKey.currentState.popUntil((route) => route.isFirst);
    } else {
      NavigationManager manager = Provider.of(context).fetch(NavigationManager);
      String _top = '';
      if (index == 0) {
        _top = 'homeTop';
      } else if (index == 1) {
        _top = 'exploreTop';
      } else if (index == 2) {
        _top = 'searchTop';
      } else if (index == 3) {
        _top = 'accountTop';
      }
      manager.changePage(_top);
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
        // navigatorKey: navigatorKey,
        home: _children[_currentIndex],
        pageRoute: PageRoutes.materialPageRoute,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        onTap: _onTappedBar,
        currentIndex: _currentIndex,
        selectedFontSize: 12.0,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            title: Text('Explore'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Account'),
          ),
        ],
      ),
    );
  }
}
