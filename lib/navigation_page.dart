import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/home_page/home_page.dart';
import 'package:windowshoppi/explore/explore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:custom_navigator/custom_navigation.dart';
import 'package:windowshoppi/search/search.dart';
import 'package:windowshoppi/auth/login.dart';

class AppNavigation extends StatefulWidget {
  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;
  bool isLoggedIn = false;

  final List<Widget> _children = [
    HomePage(),
    Explore(),
    Search(),
    LoginPage(),
  ];

  void onTappedBar(int index) {
    navigatorKey.currentState.maybePop();
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
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('home'),
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            title: Text('discover'),
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.search),
            title: Text('search'),
            backgroundColor: Colors.pink[900],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text(isLoggedIn ? 'My Account' : 'Login/Register'),
            backgroundColor: Colors.teal[700],
          ),
        ],
      ),
    );
  }
}
