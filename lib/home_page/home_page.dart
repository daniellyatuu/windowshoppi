import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/horizontal_list/horizontal_list.dart';
import 'package:windowshoppi/products/products.dart';
import 'package:windowshoppi/drawer/app_drawer.dart';
import 'package:windowshoppi/myappbar/select_country.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('windowshoppi'),
        actions: <Widget>[
          SelectCountry(),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppCategory(),
          Products(),
        ],
      ),
    );
  }
}
