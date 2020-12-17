import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class SearchArea extends StatefulWidget {
  @override
  _SearchAreaState createState() => _SearchAreaState();
}

class _SearchAreaState extends State<SearchArea> {
  bool _clearVisible = false;

  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                if (value != '') {
                  if (!_clearVisible) {
                    setState(() {
                      _clearVisible = true;
                    });
                  }
                } else {
                  setState(() {
                    _clearVisible = false;
                  });
                  // clear post list
                  BlocProvider.of<SearchPostBloc>(context)
                    ..add(ClearSearchPostResult());

                  // clear account list
                  BlocProvider.of<SearchAccountBloc>(context)
                    ..add(ClearSearchAccountResult());

                  // clear textfield
                  BlocProvider.of<SearchTextFieldBloc>(context)
                    ..add(ClearSearchedKeyword());
                }
                BlocProvider.of<SearchTextFieldBloc>(context)
                  ..add(UserTypeOnSearchField(keyword: value));
              }),
        ),
        if (_clearVisible)
          Expanded(
            flex: 0,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _clearVisible = false;
                    });
                    // clear post list
                    BlocProvider.of<SearchPostBloc>(context)
                      ..add(ClearSearchPostResult());

                    // clear account list
                    BlocProvider.of<SearchAccountBloc>(context)
                      ..add(ClearSearchAccountResult());

                    // clear textfield
                    BlocProvider.of<SearchTextFieldBloc>(context)
                      ..add(ClearSearchedKeyword());
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
