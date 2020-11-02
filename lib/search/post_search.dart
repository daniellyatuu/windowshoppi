import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:windowshoppi/bloc/bloc.dart';
import 'package:windowshoppi/repository/repository.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/search/Account.dart';
import 'package:windowshoppi/search/PostList.dart';
import 'package:windowshoppi/search/SearchArea.dart';

class PostSearch extends StatelessWidget {
  final PostsRepository postsRepository = PostsRepository(
    postsAPIClient: PostsAPIClient(
      httpClient: http.Client(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc(postsRepository: postsRepository),
      child: Provider(
        create: (context) => SearchKeywordBloc(),
        child: PostData(),
      ),
    );
  }
}

class PostData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            padding: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(50, 255, 255, 255),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            child: SearchArea(),
          ),
          bottom: TabBar(
            // onTap: (value) {
            //   print(value);
            // },
            tabs: [
              Tab(
                text: 'Posts',
              ),
              Tab(
                text: 'Accounts',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PostList(),
            Accounts(),
          ],
        ),
      ),
    );
  }
}
