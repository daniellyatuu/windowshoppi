import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('search'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final post = [
    "tv",
    "radio",
    "smartphone",
    "watch",
    "nyumba za kupanga",
    "vyakula",
    "pizza",
    "magari",
    "picha",
    "uchoraji",
  ];

  final recentSearch = [
    "radio",
    "smartphone",
    "watch",
    "nyumba za kupanga",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
//    return ListView(
//      children: <Widget>[
//        Card(
//          child: ListTile(
//            leading: Padding(
//              padding: EdgeInsets.symmetric(vertical: 8.0),
//              child: Image.asset('images/m1.jpeg'),
//            ),
//            title: Text('search result one'),
//          ),
//        ),
//      ],
//    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSearch
        : post.where((searchedText) => searchedText.startsWith(query)).toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {
                print('go to the view product page');
              },
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.asset('images/m1.jpeg'),
              ),
              title: RichText(
                text: TextSpan(
                  text: suggestionList[index].substring(0, query.length),
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
