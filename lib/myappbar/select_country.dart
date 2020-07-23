import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/models/country.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/utilities/database_helper.dart';

class SelectCountry extends StatefulWidget {
  @override
  _SelectCountryState createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  final dbHelper = DatabaseHelper.instance;

  var country = new List<Country>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    var listOfCountry = fetchCountry();
    _fetchCountry();
  }

  void _insert(data) async {
    await dbHelper.insertCountryData(data);
  }

  Future _fetchCountry() async {
    /// check if country data available on local
    final allRows = await dbHelper.queryAllRows();
//  print(allRows.length);
    if (allRows.length == 0) {
      final response = await http.get(ALL_COUNTRY_URL);
      if (response.statusCode == 200) {
        var countryData = json.decode(response.body);
        print(countryData);

        /// save data locally
        _insert(countryData);
        setState(() {
          Iterable list = countryData;
          country = list.map((model) => Country.fromJson(model)).toList();
        });
      } else {
        throw Exception('failed to load data from internet');
      }
    } else {
      setState(() {
        Iterable list = allRows;
        country = list.map((model) => Country.fromJson(model)).toList();
      });
    }

    print(country);
  }

  Widget _createListView(BuildContext context, List<Country> values) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop({'id': 2, 'name': 'Kenya'});
                },
                isDefaultAction: false,
                child: Text('Kenya'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height / 2,
              alignment: Alignment.bottomCenter,
              child: CupertinoActionSheet(
                title: Text('select country'),
                actions: <Widget>[
                  _createListView(context, country),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop('close');
                  },
                  child: Text('close'),
                ),
              ),
            );
          },
        );
      },
      child: Row(
        children: <Widget>[
          Icon(Icons.location_on),
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: Text('Tanzania'),
          ),
        ],
      ),
    );
  }
}
