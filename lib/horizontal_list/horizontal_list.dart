import 'package:flutter/material.dart';
import 'package:windowshoppi/models/category_model.dart';

class AppCategory extends StatefulWidget {
  @override
  _AppCategoryState createState() => _AppCategoryState();
}

class _AppCategoryState extends State<AppCategory> {
//  String _activeId = '1';

  final _categories = [
    CategoryList(
      id: '1',
      title: 'all',
    ),
    CategoryList(
      id: '2',
      title: 'Stores',
    ),
    CategoryList(
      id: '3',
      title: 'Restaurants',
    ),
    CategoryList(
      id: '4',
      title: 'Hotels',
    ),
    CategoryList(
      id: '5',
      title: 'NightLife',
    ),
    CategoryList(
      id: '6',
      title: 'Game Center',
    ),
    CategoryList(
      id: '7',
      title: 'Lodge',
    ),
  ];

  Widget category(CategoryList category) {
    return GestureDetector(
      onTap: () {
//        changeCategory(category.id);
      },
      child: Card(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              category.title,
              overflow: TextOverflow.ellipsis,
//              style: TextStyle(color: activeTextColor(category.id)),
            ),
          ),
        ),
      ),
    );
  }

//  changeCategory(String id) {
//    setState(() {
//      _activeId = id;
//    });
//    print('active category $_activeId');
//  }

//  Color activeTextColor(String viewId) {
//    if (_activeId == viewId) {
//      return Colors.red;
//    } else {
//      return Colors.black;
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          itemBuilder: (context, snapshot) {
            return Container(
              child: category(_categories[snapshot]),
            );
          }),
    );
  }
}
