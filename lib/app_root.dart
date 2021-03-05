import 'package:windowshoppi/src/app/create_post/create_post_files.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:windowshoppi/src/app/search/search_files.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/app/info/info_files.dart';
import 'package:windowshoppi/src/app/home/home_files.dart';
import 'package:custom_navigator/custom_navigation.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRoot extends StatefulWidget {
  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool isLoggedIn = false;

  int currentIndex;

  final List<Widget> _children = [
    Home(),
    Search(),
    Container(),
    Info(),
    Account(),
  ];

  void _onTappedBar(int index) async {
    if (index != 2) {
      if (navigatorKey.currentState.canPop()) {
        navigatorKey.currentState.popUntil((route) => route.isFirst);
      } else {
        if (currentIndex == index) {
          BlocProvider.of<ScrollToTopBloc>(context)
            ..add(ScrollToTop(index: index));
        }
      }

      BlocProvider.of<NavigationBloc>(context)..add(ChangeIndex(index: index));
    } else {
      // open bottom sheet for create post
      var result = await showCupertinoModalPopup(
        context: context,
        builder: (context) => CreatePostActionSheet(),
      );

      if (result == 'recommend') {
        // open bottom sheet for recommendation
        showCupertinoModalPopup(
          context: context,
          builder: (context) => RecommendationActionSheet(),
        );
      }
    }
  }

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavigationBloc, NavigationStates>(
      listener: (context, state) {
        if (state is CurrentIndex) {
          setState(() {
            currentIndex = state.index;
          });
        }
      },
      builder: (context, state) {
        if (state is CurrentIndex) {
          return Scaffold(
            body: CustomNavigator(
              navigatorKey: navigatorKey,
              home: IndexedStack(
                index: state.index,
                children: _children,
              ),
              pageRoute: PageRoutes.materialPageRoute,
            ),
            bottomNavigationBar: CustomNavigationBar(
              selectedColor: Color(0xff040307),
              strokeColor: Color(0x30040307),
              unSelectedColor: Color(0xffacacac),
              backgroundColor: Colors.white,
              currentIndex: state.index,
              onTap: _onTappedBar,
              items: [
                CustomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  title: Text(
                    'Home',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                CustomNavigationBarItem(
                  icon: Icon(Icons.search_outlined),
                  title: Text(
                    'Search',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                CustomNavigationBarItem(
                  icon: Icon(Icons.add_box_outlined),
                  title: Text(
                    'Post',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                CustomNavigationBarItem(
                  badgeCount: 2,
                  showBadge: true,
                  icon: Icon(
                    Icons.notifications_outlined,
                  ),
                  selectedIcon: Icon(Icons.alternate_email),
                  title: Text(
                    'Info',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                CustomNavigationBarItem(
                  icon: BlocBuilder<AuthenticationBloc, AuthenticationStates>(
                    builder: (context, state) {
                      if (state is IsAuthenticated) {
                        return state.user.profileImage == null
                            ? Icon(Icons.account_circle_outlined)
                            : Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: ExtendedImage.network(
                                    '${state.user.profileImage}',
                                    cache: true,
                                    loadStateChanged:
                                        (ExtendedImageState state) {
                                      switch (state.extendedImageLoadState) {
                                        case LoadState.loading:
                                          return FittedBox(
                                            child: Icon(
                                              Icons.account_circle_outlined,
                                              color: Colors.grey[400],
                                            ),
                                          );
                                          break;

                                        ///if you don't want override completed widget
                                        ///please return null or state.completedWidget
                                        //return null;
                                        //return state.completedWidget;
                                        case LoadState.completed:
                                          return ExtendedRawImage(
                                            fit: BoxFit.cover,
                                            image:
                                                state.extendedImageInfo?.image,
                                          );
                                          break;
                                        case LoadState.failed:
                                          return FittedBox(
                                            child: Icon(
                                              Icons.account_circle_outlined,
                                              color: Colors.grey[400],
                                            ),
                                          );
                                          break;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              );
                      } else {
                        return Icon(Icons.account_circle_outlined);
                      }
                    },
                  ),
                  title: Text(
                    'Account',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
