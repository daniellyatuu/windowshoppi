import 'package:extended_image/extended_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class UserAccount extends StatefulWidget {
  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  void _onScroll() {
    // print('detect scroll');

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    print(maxScroll);
    print(currentScroll);
    if (maxScroll - currentScroll <= _scrollThreshold) {
      // _postBloc.add(PostFetched());
      // print('fetch more data');
      // BlocProvider.of<UserPostBloc>(context)
      //   ..add(UserPostFetched(accountId: 94));
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Persistent AppBar that never scrolls
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
        centerTitle: true,
      ),
      endDrawer: UserEndDrawer(),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          // controller: _scrollController,
          // physics: NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int pdIndex) {
                    return Column(
                      children: [
                        ProfileView(),
                      ],
                    );
                  },
                  childCount: 1,
                ),
              ),
            ];
          },
          // You tab view goes here
          body: Column(
            children: <Widget>[
              TabBar(
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.grey[700],
                tabs: [
                  Tab(icon: Icon(Icons.grid_on)),
                  Tab(icon: Icon(Icons.view_list)),
                ],
              ),
              PostInit(),
            ],
          ),
        ),
      ),
    );
  }
}
