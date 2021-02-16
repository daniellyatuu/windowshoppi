import 'package:windowshoppi/src/utilities/expandable_text.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/widget/bottom_loader.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class AccountPostListView extends StatefulWidget {
  final ScrollController _primaryScrollController;
  final int accountId;
  AccountPostListView(this._primaryScrollController, this.accountId);

  @override
  _AccountPostListViewState createState() => _AccountPostListViewState();
}

class _AccountPostListViewState extends State<AccountPostListView> {
  final _scrollThreshold = 300.0;

  void _scrollListener() {
    if (context != null) {
      final maxScroll = this
          .widget
          ._primaryScrollController
          // ignore: invalid_use_of_protected_member
          .positions
          .elementAt(0)
          .maxScrollExtent;
      final currentScroll =
          // ignore: invalid_use_of_protected_member
          this.widget._primaryScrollController.positions.elementAt(0).pixels;

      if (maxScroll - currentScroll <= _scrollThreshold && currentScroll > 0) {
        BlocProvider.of<AccountPostBloc>(context)
          ..add(AccountPostFetched(accountId: this.widget.accountId));
      }
    }
  }

  Future<void> refresh() async {
    BlocProvider.of<AccountPostBloc>(context)
      ..add(AccountPostRefresh(accountId: this.widget.accountId));
    await Future.delayed(Duration(milliseconds: 700));
  }

  @override
  void initState() {
    super.initState();
    this.widget._primaryScrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountPostBloc, AccountPostStates>(
      listener: (context, state) {
        print('ACCOUNT POST list LISTENER = $state');
      },
      builder: (context, state) {
        if (state is AccountPostInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AccountPostFailure) {
          return Center(
            child: Text(
              'Failed to fetch posts',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        } else if (state is AccountPostSuccess) {
          var data = state.posts;
          if (state.posts.isEmpty) {
            return Center(
              child: Text(
                'No Posts',
                style: Theme.of(context).textTheme.headline6,
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        PostHeader(
                          post: data[index],
                        ),
                        if (data[index].group == 'vendor')
                          if (data[index].businessBio != '')
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(5.0),
                              color: Colors.black87,
                              child: ExpandableText(
                                text: '${data[index].businessBio}',
                                widgetColor: Colors.white,
                                textBold: true,
                                trimLines: 2,
                                readMore: false,
                                readLess: false,
                              ),
                            ),
                        PostImage(
                          postImage: data[index].productPhoto,
                        ),
                        AccountPostCaption(
                          post: data[index],
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
                if (!state.hasReachedMax) BottomLoader(),
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
