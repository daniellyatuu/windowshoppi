import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/search/search_files.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class SearchedAccountResult extends StatefulWidget {
  @override
  _SearchedAccountResultState createState() => _SearchedAccountResultState();
}

class _SearchedAccountResultState extends State<SearchedAccountResult> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 100.0;

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (_scrollThreshold >= maxScroll - currentScroll) {
      BlocProvider.of<SearchAccountBloc>(context)..add(SearchAccountLoadMore());
    }
  }

  void _getKeyword() {
    BlocProvider.of<SearchTextFieldBloc>(context)..add(CheckSearchedKeyword());
  }

  @override
  void initState() {
    _getKeyword();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchTextFieldBloc, SearchTextFieldStates>(
      listener: (context, state) {
        if (state is SearchTextFieldNotEmpty) {
          if (state.keyword != '') {
            // print('search for account result in  = ${state.keyword}');
            BlocProvider.of<SearchAccountBloc>(context)
              ..add(InitSearchAccountFetched(accountKeyword: state.keyword));
          }
        }
      },
      child: BlocBuilder<SearchAccountBloc, SearchAccountStates>(
        builder: (context, state) {
          if (state is SearchAccountEmpty) {
            return SearchWelcomeText(txt: 'Search Accounts');
          } else if (state is SearchAccountInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SearchAccountFailure) {
            return Center(
              child: Text(
                'Failed to fetch posts',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );
          } else if (state is SearchAccountSuccess) {
            var data = state.accounts;

            if (state.accounts.isEmpty) {
              return Center(
                child: Text(
                  'No Accounts',
                  style: Theme.of(context).textTheme.headline6,
                ),
              );
            }

            return ListView(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountPageInit(
                              accountId: data[index].accountId,
                            ),
                          ),
                        );
                      },
                      dense: true,
                      leading: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: data[index].accountProfile != null &&
                                data[index].accountProfile != ''
                            ? CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                radius: 60.0,
                                backgroundImage: NetworkImage(
                                    '${data[index].accountProfile}'),
                              )
                            : FittedBox(
                                child: Icon(Icons.account_circle,
                                    color: Colors.grey[400]),
                              ),
                      ),
                      // leading: Container(
                      //   width: 45,
                      //   height: 45,
                      //   decoration: BoxDecoration(
                      //     color: Colors.grey,
                      //     shape: BoxShape.circle,
                      //   ),
                      //   child: FittedBox(
                      //     child: Icon(
                      //       Icons.account_circle,
                      //       color: Colors.grey[300],
                      //     ),
                      //   ),
                      // ),
                      title: Text('${data[index].username}'),
                      subtitle: Text('${data[index].accountName}'),
                    );
                  },
                ),
                if (!state.hasReachedMax) BottomLoader(),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
