import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class AccountPostList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountDetailBloc, AccountDetailStates>(
      builder: (context, state) {
        if (state is AccountDetailSuccess) {
          return DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int pdIndex) {
                        return Column(
                          children: [
                            AccountPageProfile(),
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
                            AccountPostGridView(
                                innerScrollController, state.account.accountId),
                            AccountPostListView(
                                innerScrollController, state.account.accountId),
                          ],
                        ),
                      ),
                      // PostInit(),
                    ],
                  );
                },
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
