// import 'package:windowshoppi/src/app/search/search_files.dart';
// import 'package:windowshoppi/src/widget/widget_files.dart';
// import 'package:windowshoppi/src/app/home/home_files.dart';
// import 'package:windowshoppi/src/bloc/bloc_files.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class SearchedPostResult extends StatefulWidget {
//   @override
//   _SearchedPostResultState createState() => _SearchedPostResultState();
// }
//
// class _SearchedPostResultState extends State<SearchedPostResult> {
//   final _scrollController = ScrollController();
//   final _scrollThreshold = 400.0;
//
//   void _onScroll() {
//     final maxScroll = _scrollController.position.maxScrollExtent;
//     final currentScroll = _scrollController.position.pixels;
//
//     if (_scrollThreshold >= maxScroll - currentScroll) {
//       BlocProvider.of<SearchPostBloc>(context)..add(SearchPostLoadMore());
//     }
//   }
//
//   void _getKeyword() {
//     BlocProvider.of<SearchTextFieldBloc>(context)..add(CheckSearchedKeyword());
//   }
//
//   @override
//   void initState() {
//     _getKeyword();
//     _scrollController.addListener(_onScroll);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<SearchTextFieldBloc, SearchTextFieldStates>(
//       listener: (context, state) {
//         if (state is SearchTextFieldNotEmpty) {
//           if (state.keyword != '') {
//             BlocProvider.of<SearchPostBloc>(context)
//               ..add(InitSearchPostFetched(postKeyword: state.keyword));
//           }
//         }
//       },
//       child: BlocBuilder<SearchPostBloc, SearchPostStates>(
//         builder: (context, state) {
//           if (state is SearchPostEmpty) {
//             return SearchWelcomeText(txt: 'Search Posts');
//           } else if (state is SearchPostInitial) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (state is SearchPostFailure) {
//             return Center(
//               child: Text(
//                 'Failed to fetch posts',
//                 style: Theme.of(context).textTheme.bodyText1,
//               ),
//             );
//           } else if (state is SearchPostSuccess) {
//             var data = state.posts;
//
//             if (state.posts.isEmpty) {
//               return Center(
//                 child: Text(
//                   'No Posts',
//                   style: Theme.of(context).textTheme.headline6,
//                 ),
//               );
//             }
//
//             return ListView(
//               physics: BouncingScrollPhysics(),
//               controller: _scrollController,
//               children: [
//                 SinglePost(
//                   tabName: 'search post',
//                   data: data,
//                   from: 'search_post',
//                 ),
//                 if (!state.hasReachedMax) BottomLoader(),
//               ],
//             );
//           } else {
//             return Container();
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/app/search/search_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class SearchedPostResult extends StatelessWidget {
  const SearchedPostResult({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
      builder: (context, authState) {
        if (authState is IsAuthenticated) {
          return AuthSearchedPostResult(
            accountId: authState.user.accountId,
          );
        } else if (authState is IsNotAuthenticated) {
          return NotAuthSearchedPostResult();
        } else {
          return Container();
        }
      },
    );
  }
}
