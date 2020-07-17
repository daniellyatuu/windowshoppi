import 'package:flutter/material.dart';

class AppCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Category(listTitle: 'All'),
          Category(listTitle: 'Stores'),
          Category(listTitle: 'Restaurants'),
          Category(listTitle: 'Hotels'),
          Category(listTitle: 'NightLife'),
          Category(listTitle: 'Game Center'),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String listTitle;

  Category({
    this.listTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            listTitle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
