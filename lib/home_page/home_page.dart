import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/horizontal_list/horizontal_list.dart';
import 'package:windowshoppi/models/country.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/products/products.dart';
import 'package:windowshoppi/drawer/app_drawer.dart';
import 'package:windowshoppi/myappbar/select_country.dart';
import 'package:windowshoppi/utilities/database_helper.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper.instance;

//  var country = new List<Country>();

//  void _insert() async {
//    Map<String, dynamic> row = {
//      DatabaseHelper.table_2ColumnCountryId: 1,
//      DatabaseHelper.table_2ColumnCountryName: 'country name',
//      DatabaseHelper.table_2ColumnCountryFlag: 'flag.png',
//      DatabaseHelper.table_2ColumnCountryIos2: 'ios2',
//      DatabaseHelper.table_2ColumnCountryLanguage: 'language',
//      DatabaseHelper.table_2ColumnCountryCode: 'country code',
//      DatabaseHelper.table_2ColumnCountryTimezone: 'timezone',
//    };
//
//    final id = await dbHelper.insertCountryData(row);
//    print('saved id = $id');
//  }

//  void _insert() async {
//    List<Map<String, String>> row = [
//      {"name": "one"},
//      {"name": "two"},
//    ];
//
//    final id = await dbHelper.insertCountryData(row);
////    print('saved id = $id');
//  }

  void _insert(data) async {
    await dbHelper.insertCountryData(data);
  }

  void _getAllCountry() async {
    final allRows = await dbHelper.queryAllRows();
    allRows.forEach(
      (row) => print(row),
    );
  }

  void _cleanDatabase() async {
    await dbHelper.cleanDatabase();
    print('successfully');
  }

  void _countCountry() async {
    int x = await dbHelper.countCountry();
    print(x);
  }

//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
////    var listOfCountry = fetchCountry();
//    _fetchCountry();
//  }
//
//  Future _fetchCountry() async {
//    /// check if country data available on local
//    final allRows = await dbHelper.queryAllRows();
////  print(allRows.length);
//    if (allRows.length == 0) {
//      final response = await http.get(ALL_COUNTRY_URL);
//      if (response.statusCode == 200) {
//        var countryData = json.decode(response.body);
//        print(countryData);
//
//        /// save data locally
//        _insert(countryData);
//        setState(() {
//          Iterable list = countryData;
//          country = list.map((model) => Country.fromJson(model)).toList();
//        });
//      } else {
//        throw Exception('failed to load data from internet');
//      }
//    } else {
//      setState(() {
//        Iterable list = allRows;
//        country = list.map((model) => Country.fromJson(model)).toList();
//      });
//    }
//
//    print(country);
//  }

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
//              _insert();
            },
            child: Text('save country data'),
          ),
          RaisedButton(
            onPressed: () {
              _getAllCountry();
            },
            child: Text('get country data'),
          ),
          RaisedButton(
            onPressed: () {
              _cleanDatabase();
            },
            child: Text('clean database'),
          ),
          RaisedButton(
            onPressed: () {
              _countCountry();
            },
            child: Text('count country'),
          ),
          AppCategory(),
//          Products(),
        ],
      ),
    );
  }
}
