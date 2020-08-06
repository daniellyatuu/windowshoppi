import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:windowshoppi/models/category_model.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/models/category_model.dart';

class ProductCategory extends StatefulWidget {
  final Function(int) onFetchingData;
  ProductCategory({@required this.onFetchingData});

  @override
  _ProductCategoryState createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  bool _isLoading = true;
  var _categories = new List<Category>();

  int _activeId = 0;

  final _allCategory = [
    Category(
      id: 0,
      title: 'all',
    ),
  ];

  Widget category(Category category) {
    return GestureDetector(
      onTap: () {
        changeCategory(category.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Chip(
          label: Text(
            category.title,
            style: TextStyle(color: activeTextColor(category.id)),
          ),
        ),
      ),
    );
  }

  changeCategory(int id) {
    setState(() {
      _activeId = id;
    });
    widget.onFetchingData(_activeId);
//    print('active category $_activeId');
  }

  Color activeTextColor(int viewId) {
    if (_activeId == viewId) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategory(TOP30_CATEGORY);
  }

  Future fetchCategory(url) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var categoryData = json.decode(response.body);

      setState(() {
        Iterable list = categoryData;
        _categories = list.map((model) => Category.fromJson(model)).toList();

        // append category with title "ALL"
        _categories = _allCategory + _categories;
      });
//      print(_categories);
    } else {
      throw Exception('failed to load data from internet');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (_) {
//        if (_isLoading) {
//          return Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
//            child: SizedBox(
//              height: 2.0,
//              child: LinearProgressIndicator(),
//            ),
//          );
//        }
        return Container(
          height: 50.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, snapshot) {
              return Container(
                child: category(_categories[snapshot]),
              );
            },
          ),
        );
      },
    );
  }
}
