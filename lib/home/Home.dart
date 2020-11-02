// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:windowshoppi/bloc/PostBloc.dart';
// import 'package:windowshoppi/bloc/PostEvent.dart';
// import 'package:http/http.dart' as http;
// import 'package:windowshoppi/bloc/PostState.dart';
// import 'package:windowshoppi/drawer/app_drawer.dart';
// import 'package:windowshoppi/home/PostWidget.dart';
// import 'package:windowshoppi/models/post.dart';
// import 'package:windowshoppi/myappbar/select_country.dart';
// import 'package:windowshoppi/widgets/loader.dart';
//
// class Home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           PostBloc(httpClient: http.Client())..add(PostFetched()),
//       child: HomeInit(),
//     );
//   }
// }
//
// class HomeInit extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'windowshoppi ',
//         ),
//         actions: <Widget>[
//           SelectCountry(
//             onCountryChanged: () {
//               // state.posts.clear();
//               BlocProvider.of<PostBloc>(context).add(
//                 PostFetched(),
//               );
//             },
//             countryIos2: (value) => null,
//           ),
//         ],
//       ),
//       drawer: AppDrawer(),
//       body: HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   PostBloc _postBloc;
//   List<Post> _posts = [];
//
//   final _scrollController = ScrollController();
//   final _scrollThreshold = 200.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//     _postBloc = BlocProvider.of<PostBloc>(context);
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _onScroll() {
//     final maxScroll = _scrollController.position.maxScrollExtent;
//     final currentScroll = _scrollController.position.pixels;
//     if (maxScroll - currentScroll <= _scrollThreshold) {
//       _postBloc..add(PostFetched());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: BlocListener<PostBloc, PostState>(
//         listener: (context, state) {
//           if (state is PostSuccess) {
//             // print(state);
//             // print('up her');
//             _posts = [];
//             _posts.addAll(state.posts);
//           }
//         },
//         child: BlocBuilder<PostBloc, PostState>(
//           builder: (context, state) {
//             // print(state);
//             if (state is PostFailure) {
//               return Center(
//                 child: Text('$state'),
//               );
//             }
//             if (state is PostInitial) {
//               return Container(
//                 child: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//             } else if (state is PostSuccess) {
//               return RefreshIndicator(
//                 onRefresh: () async {
//                   // _posts = [];
//                   state.posts.clear();
//                   BlocProvider.of<PostBloc>(context).add(
//                     PostFetched(),
//                   );
//                   await Future.delayed(Duration(seconds: 1));
//                 },
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Expanded(
//                       child: Container(
//                         child: StaggeredGridView.countBuilder(
//                           physics: BouncingScrollPhysics(),
//                           controller: _scrollController,
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 1,
//                           mainAxisSpacing: 1,
//                           itemCount: _posts.length,
//                           itemBuilder: (context, index) {
//                             // print('inside UI/UX');
//                             // print(state.posts);
//                             return index >= state.posts.length
//                                 ? BottomLoader()
//                                 : PostWidget(post: state.posts[index]);
//                           },
//                           staggeredTileBuilder: (index) {
//                             return StaggeredTile.count(
//                                 1, index.isEven ? 1.1 : 1.4);
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 // child: ListView.builder(
//                 //   controller: _scrollController,
//                 //   itemCount: _posts.length,
//                 //   itemBuilder: (context, index) {
//                 //     final post = _posts[index];
//                 //     return Card(
//                 //       child: Container(
//                 //         color: Colors.red,
//                 //         height: 1000,
//                 //         child: Text(post.id.toString()),
//                 //       ),
//                 //     );
//                 //   },
//                 // ),
//               );
//             } else {
//               return Container(
//                 child: Center(
//                   child: Text('You have an error'),
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
//
// // class HomePage extends StatefulWidget {
// //   @override
// //   _HomePageState createState() => _HomePageState();
// // }
// //
// // class _HomePageState extends State<HomePage> {
// //   final _scrollController = ScrollController();
// //   final _scrollThreshold = 200.0;
// //   PostBloc _postBloc;
// //
// //   Future<void> refresh() async {
// //     await Future.delayed(Duration(milliseconds: 700));
// //
// //     // _postBloc = BlocProvider.of<PostBloc>(context);
// //     // _postBloc.add(PostFetched());
// //     PostBloc(httpClient: http.Client())..add(PostFetched());
// //     setState(() {});
// //   }
// //
// //   Future<void> _clearPost(state) async {
// //     state.posts.clear();
// //     // await Future.delayed(Duration(seconds: 5));
// //     setState(() {});
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _scrollController.addListener(_onScroll);
// //     _postBloc = BlocProvider.of<PostBloc>(context);
// //     // _postBloc.add(PostFetched());
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocBuilder<PostBloc, PostState>(
// //       builder: (context, state) {
// //         if (state is PostInitial) {
// //           return Center(
// //             child: CircularProgressIndicator(),
// //           );
// //         }
// //         if (state is PostFailure) {
// //           return Center(
// //             child: Text('failed to fetch posts'),
// //           );
// //         }
// //         if (state is PostSuccess) {
// //           if (state.posts.isEmpty) {
// //             return Center(
// //               child: Text('no posts'),
// //             );
// //           }
// //           return RefreshIndicator(
// //             onRefresh: () async {
// //               await Future.delayed(Duration(milliseconds: 700));
// //               await _clearPost(state);
// //               _postBloc.add(PostFetched());
// //               // PostBloc(httpClient: http.Client())..add(PostFetched());
// //             },
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: <Widget>[
// //                 Expanded(
// //                   child: Container(
// //                     child: StaggeredGridView.countBuilder(
// //                       physics: BouncingScrollPhysics(),
// //                       controller: _scrollController,
// //                       crossAxisCount: 2,
// //                       crossAxisSpacing: 1,
// //                       mainAxisSpacing: 1,
// //                       itemCount: state.hasReachedMax
// //                           ? state.posts.length
// //                           : state.posts.length + 1,
// //                       itemBuilder: (context, index) {
// //                         // print('inside UI/UX');
// //                         // print(state.posts);
// //                         return index >= state.posts.length
// //                             ? BottomLoader()
// //                             : PostWidget(post: state.posts[index]);
// //                       },
// //                       staggeredTileBuilder: (index) {
// //                         return StaggeredTile.count(1, index.isEven ? 1.1 : 1.4);
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }
// //         return Center(
// //           child: Text(
// //             'Error occurred',
// //             style: Theme.of(context).textTheme.subtitle1,
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     _scrollController.dispose();
// //     super.dispose();
// //   }
// //
// //   void _onScroll() {
// //     final maxScroll = _scrollController.position.maxScrollExtent;
// //     final currentScroll = _scrollController.position.pixels;
// //     if (maxScroll - currentScroll <= _scrollThreshold) {
// //       _postBloc.add(PostFetched());
// //     }
// //   }
// // }
