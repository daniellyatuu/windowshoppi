import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:windowshoppi/bloc/bloc.dart';

class Accounts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SearchKeywordBloc>(context);
    bloc.searchedKeyword.listen(
      (event) {
        print('result in account = ' + event);
      },
    );
    return ListView.separated(
      itemCount: 20,
      itemBuilder: (context, index) {
        return ListTile(
          dense: true,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80'),
          ),
          title: Text('Account ${index + 1}'),
          subtitle: Text('Account location Account location'),
          trailing: OutlineButton(
            onPressed: () {},
            child: Text(
              "visit",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            borderSide: BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(),
    );
  }
}
