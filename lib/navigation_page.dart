import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:windowshoppi/auth/user_auth.dart';
import 'package:windowshoppi/home_page/home_page.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/explore/explore_files.dart';
import 'package:windowshoppi/src/search/search_files.dart';
import 'package:custom_navigator/custom_navigation.dart';
import 'package:windowshoppi/src/home/home_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppNavigation extends StatefulWidget {
  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;
  bool isLoggedIn = false;

  // final List<Widget> _children = [
  //   HomePage(),
  //   Explore(),
  //   Search(),
  //   UserAuth(),
  // ];

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
      // print('scroll page to top');
      // NavigationManager manager = Provider.of(context).fetch(NavigationManager);
      // String _top = '';
      // if (index == 0) {
      //   _top = 'homeTop';
      // } else if (index == 1) {
      //   _top = 'exploreTop';
      // } else if (index == 2) {
      //   _top = 'searchTop';
      // } else if (index == 3) {
      //   _top = 'accountTop';
      // }
      // manager.changePage(_top);
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
