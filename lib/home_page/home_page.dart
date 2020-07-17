import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/horizontal_list/horizontal_list.dart';
import 'package:windowshoppi/products/products.dart';
import 'package:windowshoppi/drawer/app_drawer.dart';
import 'package:windowshoppi/myappbar/select_country.dart';
import 'package:windowshoppi/utilities/database_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper.instance;
  List countries;

  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.table_2ColumnCountryId: 1,
      DatabaseHelper.table_2ColumnCountryName: 'country name',
      DatabaseHelper.table_2ColumnCountryFlag: 'flag.png',
      DatabaseHelper.table_2ColumnCountryIos2: 'ios2',
      DatabaseHelper.table_2ColumnCountryLanguage: 'language',
      DatabaseHelper.table_2ColumnCountryCode: 'country code',
      DatabaseHelper.table_2ColumnCountryTimezone: 'timezone',
    };

    final id = await dbHelper.insert(row);
    print('saved id = $id');
  }

  void _getAllCountry() async {
    final allRows = await dbHelper.queryAllRows();
    allRows.forEach(
      (row) => print(row),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'windowshoppi ',
          style: TextStyle(fontFamily: 'Itim'),
        ),
        actions: <Widget>[
          SelectCountry(),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              _insert();
            },
            child: Text('save country data'),
          ),
          RaisedButton(
            onPressed: () {
              _getAllCountry();
            },
            child: Text('get country data'),
          ),
          AppCategory(),
          Products(),
        ],
      ),
    );
  }
}
