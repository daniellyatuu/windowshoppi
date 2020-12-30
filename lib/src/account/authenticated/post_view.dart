import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class PostView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
      builder: (context, state) {
        if (state is IsAuthenticated) {
          return Scaffold(
            appBar: AppBar(
              title: Text("@${state.user.username}"),
              centerTitle: true,
            ),
            endDrawer: UserEndDrawer(),
            body: DefaultTabController(
              length: 2,
              child: NestedScrollView(
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
                body: Builder(
                  builder: (BuildContext context) {
                    final innerScrollController =
                        PrimaryScrollController.of(context);

                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        TabBar(
                          unselectedLabelColor: Colors.grey,
                          labelColor: Colors.grey[700],
                          tabs: [
                            Tab(icon: Icon(Icons.grid_on)),
                            Tab(icon: Icon(Icons.view_list)),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              PostGridView(
                                  innerScrollController, state.user.accountId),
                              PostListView(
                                  innerScrollController, state.user.accountId),
                            ],
                          ),
                        ),
                        // PostInit(),
                      ],
                    );
                  },
                ),
              ),
            ),
            floatingActionButton: SelectImageButton(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
