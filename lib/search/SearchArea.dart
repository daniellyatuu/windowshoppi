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
              BlocProvider.of<PostBloc>(context)
                  .add(FetchPosts(keyword: value));
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
                  BlocProvider.of<PostBloc>(context).add(ResetPosts());
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
