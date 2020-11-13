import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class UserAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthenticationBloc, AuthenticationStates>(
          builder: (context, state) {
            if (state is IsAuthenticated) {
              return Text("@${state.user.username}");
            } else {
              return Container();
            }
          },
        ),
      ),
      endDrawer: UserEndDrawer(),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          physics: NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, isScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                collapsedHeight: MediaQuery.of(context).size.height / 4,
                expandedHeight: MediaQuery.of(context).size.height / 4,
                actions: [Container()],
                flexibleSpace: ProfileView(),
              ),
              SliverPersistentHeader(
                delegate: AccountDelegate(
                  TabBar(
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.grey[700],
                    tabs: [
                      Tab(icon: Icon(Icons.grid_on)),
                      Tab(icon: Icon(Icons.list)),
                    ],
                  ),
                ),
                floating: true,
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              Center(
                child: Text('1'),
              ),
              Center(
                child: Text('2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class UserAccount extends StatelessWidget {
//   List<String> posts = [
//     'https://www.jpl.nasa.gov/spaceimages/images/largesize/PIA23689_hires.jpg',
//     'https://www.jpl.nasa.gov/spaceimages/images/largesize/PIA23689_hires.jpg',
//     'https://www.jpl.nasa.gov/spaceimages/images/largesize/PIA23689_hires.jpg',
//     'https://www.jpl.nasa.gov/spaceimages/images/largesize/PIA23689_hires.jpg',
//     'https://www.jpl.nasa.gov/spaceimages/images/largesize/PIA23689_hires.jpg',
//     'https://www.jpl.nasa.gov/spaceimages/images/largesize/PIA23689_hires.jpg',
//     'https://www.jpl.nasa.gov/spaceimages/images/largesize/PIA23689_hires.jpg',
//     'https://www.jpl.nasa.gov/spaceimages/images/largesize/PIA23689_hires.jpg',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('username'),
//       ),
//       body: DefaultTabController(
//         length: 3,
//         child: NestedScrollView(
//           physics: NeverScrollableScrollPhysics(),
//           headerSliverBuilder: (context, isScrolled) {
//             return [
//               SliverAppBar(
//                 backgroundColor: Colors.grey[300],
//                 collapsedHeight: 150,
//                 expandedHeight: 150,
//                 flexibleSpace: ProfileView(),
//               ),
//               SliverPersistentHeader(
//                 delegate: MyDelegate(
//                   TabBar(
//                     labelColor: Colors.black,
//                     tabs: [
//                       Tab(icon: Icon(Icons.grid_on)),
//                       Tab(icon: Icon(Icons.grid_on)),
//                       Tab(icon: Icon(Icons.grid_on)),
//                     ],
//                   ),
//                 ),
//                 floating: true,
//                 pinned: true,
//               ),
//             ];
//           },
//           body: TabBarView(
//             children: [
//               Center(
//                 child: Text('1'),
//               ),
//               Center(
//                 child: Text('2'),
//               ),
//               Center(
//                 child: Text('3'),
//               ),
//             ],
//           ),
//           // body: TabBarView(
//           //   children: [1, 2, 3]
//           //       .map((e) => GridView.count(
//           //             physics: BouncingScrollPhysics(),
//           //             crossAxisCount: 3,
//           //             shrinkWrap: true,
//           //             mainAxisSpacing: 2.0,
//           //             crossAxisSpacing: 2.0,
//           //             children: posts
//           //                 .map(
//           //                   (e) => Container(
//           //                     child: Image.network(e),
//           //                   ),
//           //                 )
//           //                 .toList(),
//           //           ))
//           //       .toList(),
//           // ),
//         ),
//       ),
//     );
//   }
// }
//
// class MyDelegate extends SliverPersistentHeaderDelegate {
//   final TabBar tabBar;
//   MyDelegate(this.tabBar);
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Colors.white,
//       child: tabBar,
//     );
//   }
//
//   @override
//   double get maxExtent => tabBar.preferredSize.height;
//
//   @override
//   double get minExtent => tabBar.preferredSize.height;
//
//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }
//
// class ProfileView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 CircleAvatar(
//                   radius: 40,
//                   child: Icon(Icons.account_circle),
//                 ),
//                 Column(
//                   children: [
//                     Text(
//                       '30',
//                       style: Theme.of(context).textTheme.headline5,
//                     ),
//                     SizedBox(
//                       height: 10.0,
//                     ),
//                     Text(
//                       'Posts',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Text(
//                       '130k',
//                       style: Theme.of(context).textTheme.headline5,
//                     ),
//                     SizedBox(
//                       height: 10.0,
//                     ),
//                     Text(
//                       'Followers',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Text(
//                       '50',
//                       style: Theme.of(context).textTheme.headline5,
//                     ),
//                     SizedBox(
//                       height: 10.0,
//                     ),
//                     Text(
//                       'Following',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.all(20.0),
//             child: Text('account bio'),
//           ),
//         ],
//       ),
//     );
//   }
// }
