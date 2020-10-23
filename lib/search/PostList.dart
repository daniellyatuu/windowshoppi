import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:windowshoppi/bloc/bloc.dart';

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  void search() {
    print('ok');
    final SearchKeywordBloc _textBloc = SearchKeywordBloc();
    _textBloc.isFormValid.listen((event) {
      print('show in here');
    });
    // _textBloc.searchedKeyword.listen((event) {
    //   print('request');
    //   print(event);
    // });
  }

  @override
  void initState() {
    print('init state');
    search();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostBloc, PostStates>(
      listener: (context, PostStates state) {
        if (state is PostLoaded) {
          print('Im here');
        }
      },
      builder: (context, PostStates state) {
        print('step 4 : ' + state.toString());
        if (state is PostEmpty) {
          return PostBody();
        } else if (state is PostLoading) {
          return Container(
            padding: EdgeInsets.only(top: 20.0),
            alignment: Alignment.topCenter,
            child: CircularProgressIndicator(),
          );
        } else if (state is PostLoaded) {
          final posts = state.post;

          if (posts.isEmpty) {
            return Container(
              padding: EdgeInsets.only(top: 20.0),
              alignment: Alignment.topCenter,
              child: Text('No posts'),
            );
          }

          return ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(posts[index].accountName),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: posts.length);
        }
        return Text('');
      },
    );
  }
}

class PostBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SearchKeywordBloc>(context);
    bloc.searchedKeyword.listen(
      (event) {
        print('result in post = ' + event);
      },
    );
    return Center(
      child: ListView(
        children: [
          StreamBuilder<Object>(
            stream: bloc.searchedKeyword,
            builder: (context, snapshot) {
              return Text(snapshot.data ?? '');
            },
          ),
          RaisedButton(
            onPressed: () {
              BlocProvider.of<PostBloc>(context)
                  .add(FetchPosts(keyword: 'Los Angeles'));
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
