import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:windowshoppi/bloc/bloc.dart';

class SearchArea extends StatefulWidget {
  @override
  _SearchAreaState createState() => _SearchAreaState();
}

class _SearchAreaState extends State<SearchArea> {
  final _controller = TextEditingController();

  void _searchedKeyword(value) {
    print('inside');
    final bloc = Provider.of<SearchKeywordBloc>(context);
    print('ype');
    bloc.setKeyword(value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SearchKeywordBloc>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: TextField(
            controller: _controller,
            autofocus: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            onChanged: (value) {
              bloc.setKeyword(value);
              // _searchedKeyword(value);
              bloc.searchedKeyword.listen((event) {
                print('inside onChange = ' + event);
              });
              // BlocProvider.of<PostBloc>(context)
              //     .add(FetchPosts(keyword: value));
            },
          ),
        ),
        Expanded(
          flex: 0,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  _controller.clear();
                  bloc.setKeyword('');
                  // BlocProvider.of<PostBloc>(context).add(ResetPosts());
                  // BlocProvider.of<PostBloc>(context)
                  //     .add(FetchPosts(city: 'Los Angeles'));
                },
                icon: Icon(Icons.clear),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
